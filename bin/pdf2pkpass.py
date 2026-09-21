# Model: GPT-5 Thinking mini
# Thinking: enabled
# Date: 2025-10-22

"""
Minimal pkpass builder from an insurance-card PDF.
Requirements (system): openssl (required). Optional: pdftotext, pdftoppm/convert, tesseract (if OCR needed).
Edit CONFIG entries for your passTypeIdentifier, teamIdentifier, and certificate paths.
"""

import os
import sys
import json
import hashlib
import shutil
import tempfile
import subprocess
from pathlib import Path

# ---------- CONFIG: set these ----------
PASS_TYPE_IDENTIFIER = "pass.com.example.insurance"  # from Apple Developer
TEAM_IDENTIFIER = "ABCDE12345"                       # your Apple team id
ORGANIZATION_NAME = "Example Insurance"
SERIAL_NUMBER = "policy-00001"                       # unique per pass
DESCRIPTION = "Insurance Card"
P12_PATH = "/path/to/pass_certificate.p12"           # Pass Type ID certificate (.p12)
P12_PASSWORD = "p12password"                         # if any; empty string if none
WWDR_CERT_PATH = "/path/to/AppleWWDRCAG3.cer"        # Apple WWDR cert (download from Apple)
OUTPUT_PKPASS = "insurance_card.pkpass"
# Path to user's PDF
PDF_PATH = "/Users/ian/digital_receipts/metlife_insurance_card.pdf"
# Optional system tools (if present)
PDFTOTEXT = shutil.which("pdftotext")
PDFTOPPM = shutil.which("pdftoppm") or shutil.which("convert")  # convert if pdftoppm absent
TESSERACT = shutil.which("tesseract")
# --------------------------------------

def extract_text_from_pdf(pdf_path, out_txt):
    """Try pdftotext, fallback to tesseract OCR on rendered PNG if available."""
    if PDFTOTEXT:
        print("Using pdftotext...")
        subprocess.check_call([PDFTOTEXT, pdf_path, out_txt])
        return Path(out_txt).read_text(encoding="utf-8", errors="ignore")
    else:
        print("pdftotext not found; trying pdftoppm/convert + tesseract for OCR (if available).")
        tmpdir = tempfile.mkdtemp()
        try:
            png_base = os.path.join(tmpdir, "page")
            if shutil.which("pdftoppm"):
                subprocess.check_call(["pdftoppm", "-png", pdf_path, png_base])
                page0 = png_base + "-1.png"
            elif shutil.which("convert"):
                # ImageMagick convert: first page
                page0 = os.path.join(tmpdir, "page.png")
                subprocess.check_call(["convert", f"{pdf_path}[0]", page0])
            else:
                raise RuntimeError("No tool to rasterize PDF found (pdftoppm or convert).")
            if TESSERACT:
                txt_out = out_txt
                subprocess.check_call([TESSERACT, page0, txt_out.replace(".txt","")])
                return Path(txt_out).read_text(encoding="utf-8", errors="ignore")
            else:
                raise RuntimeError("No OCR (tesseract) and no text extractor available.")
        finally:
            shutil.rmtree(tmpdir, ignore_errors=True)

def render_icon_from_pdf(pdf_path, png_out, size_px=180):
    """Create a simple PNG from the first page for icon/logo using pdftoppm or convert if available."""
    if shutil.which("pdftoppm"):
        subprocess.check_call(["pdftoppm", "-png", "-singlefile", pdf_path, png_out.replace(".png","")])
        return png_out
    elif shutil.which("convert"):
        subprocess.check_call(["convert", f"{pdf_path}[0]", "-resize", f"{size_px}x{size_px}", png_out])
        return png_out
    else:
        raise RuntimeError("No tool to create image from PDF (pdftoppm or convert).")

def sha1_of_bytes(b):
    h = hashlib.sha1()
    h.update(b)
    return h.hexdigest()

def build_pass(tmpdir, extracted_text):
    # Minimal pass.json template for a generic storeCard -- adapt fields and keys to your needs.
    pass_json = {
        "formatVersion": 1,
        "passTypeIdentifier": PASS_TYPE_IDENTIFIER,
        "teamIdentifier": TEAM_IDENTIFIER,
        "organizationName": ORGANIZATION_NAME,
        "serialNumber": SERIAL_NUMBER,
        "description": DESCRIPTION,
        # Example structure: a storeCard with primaryFields and secondaryFields
        "boardingPass": {},  # keep empty unless making a boarding pass
        "storeCard": {
            "primaryFields": [
                {"key": "memberName", "label": "Name", "value": "UNKNOWN"}
            ],
            "secondaryFields": [
                {"key": "policyNumber", "label": "Policy #", "value": "UNKNOWN"}
            ],
            "auxiliaryFields": [
                {"key": "group", "label": "Group", "value": "UNKNOWN"}
            ]
        },
        "barcode": {
            "message": "UNKNOWN",
            "format": "PKBarcodeFormatQR",
            "messageEncoding": "iso-8859-1"
        }
    }

    # naive parsing: try to find policy number, name, group from extracted_text (customize regexes)
    import re
    m = re.search(r"Policy(?:\s*#| number| no\.)\s*[:#]?\s*([A-Za-z0-9-]+)", extracted_text, re.IGNORECASE)
    if m:
        pass_json["storeCard"]["secondaryFields"][0]["value"] = m.group(1)
        pass_json["barcode"]["message"] = m.group(1)

    m = re.search(r"Group(?:\s*#| number)?\s*[:#]?\s*([A-Za-z0-9-]+)", extracted_text, re.IGNORECASE)
    if m:
        pass_json["storeCard"]["auxiliaryFields"][0]["value"] = m.group(1)

    # A simple heuristic for name: look for two capitalized words on the card
    m = re.search(r"\n([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+)\n", extracted_text)
    if m:
        pass_json["storeCard"]["primaryFields"][0]["value"] = m.group(1).strip()

    # write pass.json
    pass_json_path = os.path.join(tmpdir, "pass.json")
    with open(pass_json_path, "w", encoding="utf-8") as f:
        json.dump(pass_json, f, ensure_ascii=False, indent=2)
    return pass_json_path

def build_manifest_and_signature(tmpdir, p12_path, p12_password, wwdr_path):
    # compute SHA1 for each file in tmpdir
    manifest = {}
    for entry in sorted(os.listdir(tmpdir)):
        full = os.path.join(tmpdir, entry)
        if os.path.isfile(full):
            with open(full, "rb") as f:
                manifest[entry] = sha1_of_bytes(f.read())
    manifest_path = os.path.join(tmpdir, "manifest.json")
    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2, sort_keys=True)
    if False:
        # Extract cert and key from p12 to temporary PEM files (openssl required)
        cert_pem = os.path.join(tmpdir, "cert.pem")
        key_pem = os.path.join(tmpdir, "key.pem")
        # -nodes to keep private key unencrypted in PEM (we use it immediately)
        pkcs12_cmd = ["openssl", "pkcs12", "-in", p12_path, "-out", os.path.join(tmpdir, "full.pem"), "-nodes"]
        if p12_password:
            pkcs12_cmd += ["-passin", f"pass:{p12_password}"]
        subprocess.check_call(pkcs12_cmd)
        # split full.pem into cert.pem and key.pem
        fullpem = Path(os.path.join(tmpdir, "full.pem")).read_text()
        # crude splitting by BEGIN/END markers
        cert_texts = []
        key_texts = []
        current = None
        for line in fullpem.splitlines(True):
            if "-----BEGIN CERTIFICATE-----" in line:
                current = cert_texts
            if "-----BEGIN PRIVATE KEY-----" in line or "-----BEGIN RSA PRIVATE KEY-----" in line:
                current = key_texts
            if current is not None:
                current.append(line)
            if "-----END CERTIFICATE-----" in line:
                current = None
            if "-----END PRIVATE KEY-----" in line or "-----END RSA PRIVATE KEY-----" in line:
                current = None
        Path(cert_pem).write_text("".join(cert_texts))
        Path(key_pem).write_text("".join(key_texts))
        # Now sign manifest.json with openssl smime (PKCS7) producing a DER signature file named "signature"
        manifest_path = os.path.join(tmpdir, "manifest.json")
        signature_path = os.path.join(tmpdir, "signature")
        smime_cmd = [
            "openssl", "smime", "-binary", "-sign",
            "-signer", cert_pem,
            "-inkey", key_pem,
            "-certfile", wwdr_path,
            "-in", manifest_path,
            "-out", signature_path,
            "-outform", "DER",
            "-nodetach"
        ]
        subprocess.check_call(smime_cmd)
    else:
        signature_path = ''
    return manifest_path, signature_path

def make_pkpass(tmpdir, out_path):
    # create zip with files in tmpdir (no compression recommended but zipped works)
    cwd = os.getcwd()
    try:
        os.chdir(tmpdir)
        # write zip into out_path
        shutil.make_archive(out_path.replace(".pkpass",""), 'zip', root_dir='.')
        # rename .zip to .pkpass
        if os.path.exists(out_path):
            os.remove(out_path)
        os.rename(out_path.replace(".pkpass","") + ".zip", out_path)
    finally:
        os.chdir(cwd)

def main():
    if not os.path.exists(PDF_PATH):
        print("PDF not found:", PDF_PATH)
        sys.exit(1)
    tmpdir = tempfile.mkdtemp()
    try:
        textfile = os.path.join(tmpdir, "extracted.txt")
        try:
            extracted_text = extract_text_from_pdf(PDF_PATH, textfile)
        except Exception as e:
            print("Text extraction failed:", e)
            extracted_text = ""
        print("Extracted text sample:", extracted_text[:200].replace("\n","\\n"))

        pass_json_path = build_pass(tmpdir, extracted_text)

        # create a simple icon from PDF for the pass (icon.png and logo.png recommended)
        try:
            icon_path = os.path.join(tmpdir, "icon.png")
            render_icon_from_pdf(PDF_PATH, icon_path)
            # Apple requires certain size variants for icon and logo; you may want to resize appropriately.
            # Also include logo.png if desired.
        except Exception as e:
            print("Could not render icon from PDF:", e)

        # build manifest and signature
        manifest_path, signature_path = build_manifest_and_signature(tmpdir, P12_PATH, P12_PASSWORD, WWDR_CERT_PATH)

        # create the .pkpass
        make_pkpass(tmpdir, OUTPUT_PKPASS)
        print("Created pkpass:", OUTPUT_PKPASS)
    finally:
        # keep tmpdir for debugging; remove if you want
        print("Temporary files in:", tmpdir)
        # shutil.rmtree(tmpdir)  # uncomment to remove temp files automatically

if __name__ == "__main__":
    main()

