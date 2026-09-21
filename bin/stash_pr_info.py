#!/usr/bin/env python3
"""Fetch Bitbucket PR info for code review: diff, state, comments, and frontmatter."""

import argparse
import json
import os
import re
import sys
import urllib.request
import urllib.error
import textwrap


BASE_URL = "https://stashweb.sd.apple.com"
API_BASE = f"{BASE_URL}/rest/api/1.0"
TOKEN_PATH = os.path.expanduser("~/.stash_access_token")


def load_token():
    try:
        return open(TOKEN_PATH).read().strip()
    except FileNotFoundError:
        sys.exit(f"No access token found at {TOKEN_PATH}")


def parse_pr_url(url):
    """Extract project, repo, and PR ID from a Bitbucket PR URL."""
    m = re.match(
        r"https?://stashweb\.sd\.apple\.com/projects/([^/]+)/repos/([^/]+)/pull-requests/(\d+)",
        url,
    )
    if not m:
        sys.exit(f"Could not parse PR URL: {url}")
    return m.group(1), m.group(2), int(m.group(3))


def api_get(path, accept="application/json"):
    """GET from the Bitbucket REST API using personal access token."""
    url = f"{API_BASE}{path}"
    token = load_token()
    req = urllib.request.Request(url, headers={
        "Accept": accept,
        "Authorization": f"Bearer {token}",
    })
    try:
        with urllib.request.urlopen(req) as resp:
            return resp.read()
    except urllib.error.HTTPError as e:
        body = e.read().decode(errors="replace")
        sys.exit(f"HTTP {e.code} fetching {url}\n{body}")


def api_get_json(path):
    return json.loads(api_get(path))


def api_get_paged(path):
    """Handle Bitbucket's paged API responses."""
    results = []
    start = 0
    while True:
        sep = "&" if "?" in path else "?"
        data = api_get_json(f"{path}{sep}start={start}&limit=100")
        results.extend(data.get("values", []))
        if data.get("isLastPage", True):
            break
        start = data.get("nextPageStart", start + 100)
    return results


def get_diff(project, repo, pr_id):
    """Fetch the unified diff."""
    path = f"/projects/{project}/repos/{repo}/pull-requests/{pr_id}/diff"
    # Request raw diff text
    url = f"{BASE_URL}/rest/api/1.0{path}?contextLines=5&withComments=false"
    token = load_token()
    req = urllib.request.Request(url, headers={
        "Accept": "text/plain",
        "Authorization": f"Bearer {token}",
    })
    try:
        with urllib.request.urlopen(req) as resp:
            return resp.read().decode(errors="replace")
    except urllib.error.HTTPError:
        # Fall back to JSON diff and format it ourselves
        data = api_get_json(f"{path}?contextLines=5&withComments=false")
        return format_json_diff(data)


def format_json_diff(data):
    """Format Bitbucket's JSON diff response into a readable unified-ish diff."""
    lines = []
    for d in data.get("diffs", []):
        src = d.get("source", {}).get("toString", "/dev/null")
        dst = d.get("destination", {}).get("toString", "/dev/null")
        lines.append(f"--- a/{src}")
        lines.append(f"+++ b/{dst}")
        for hunk in d.get("hunks", []):
            src_line = hunk.get("sourceLine", 0)
            src_span = hunk.get("sourceSpan", 0)
            dst_line = hunk.get("destinationLine", 0)
            dst_span = hunk.get("destinationSpan", 0)
            lines.append(f"@@ -{src_line},{src_span} +{dst_line},{dst_span} @@")
            for seg in hunk.get("segments", []):
                prefix = {"ADDED": "+", "REMOVED": "-", "CONTEXT": " "}.get(
                    seg.get("type", "CONTEXT"), " "
                )
                for ln in seg.get("lines", []):
                    lines.append(f"{prefix}{ln.get('line', '')}")
        lines.append("")
    return "\n".join(lines)


def format_user(user_obj):
    if not user_obj:
        return "unknown"
    name = user_obj.get("displayName", user_obj.get("name", "unknown"))
    email = user_obj.get("emailAddress", "")
    return f"{name} <{email}>" if email else name


def print_frontmatter(pr):
    """Print PR metadata."""
    print("=" * 72)
    print(f"PR #{pr['id']}: {pr['title']}")
    print("=" * 72)
    print(f"State:    {pr['state']}")
    print(f"Author:   {format_user(pr.get('author', {}).get('user'))}")
    print(f"Created:  {pr.get('createdDate', 'N/A')}")
    print(f"Updated:  {pr.get('updatedDate', 'N/A')}")

    src = pr.get("fromRef", {})
    dst = pr.get("toRef", {})
    print(f"Branch:   {src.get('displayId', '?')} -> {dst.get('displayId', '?')}")

    reviewers = pr.get("reviewers", [])
    if reviewers:
        for r in reviewers:
            status = r.get("status", "UNAPPROVED")
            print(f"Reviewer: {format_user(r.get('user'))} [{status}]")

    desc = pr.get("description", "")
    if desc:
        print(f"\nDescription:\n{textwrap.indent(desc, '  ')}")
    print()


def print_comments(project, repo, pr_id):
    """Fetch and print PR activity (comments)."""
    activities = api_get_paged(
        f"/projects/{project}/repos/{repo}/pull-requests/{pr_id}/activities"
    )
    comments = [a for a in activities if a.get("action") == "COMMENTED"]
    if not comments:
        print("No comments.\n")
        return

    print("-" * 72)
    print("COMMENTS")
    print("-" * 72)
    for act in comments:
        comment = act.get("comment", {})
        print_comment(comment, indent=0)
    print()


def print_comment(comment, indent=0):
    prefix = "  " * indent
    author = format_user(comment.get("author"))
    text = comment.get("text", "")
    severity = comment.get("severity", "")
    anchor = comment.get("anchor", {})

    loc = ""
    if anchor:
        path = anchor.get("path", "")
        line = anchor.get("line")
        if path:
            loc = f" on {path}"
            if line:
                loc += f":{line}"

    tag = f" [{severity}]" if severity and severity != "NORMAL" else ""
    print(f"{prefix}>> {author}{loc}{tag}")
    for line in text.splitlines():
        print(f"{prefix}   {line}")
    print()

    # Print replies
    for reply in comment.get("comments", []):
        print_comment(reply, indent=indent + 1)


def main():
    parser = argparse.ArgumentParser(description="Fetch Bitbucket PR for code review")
    parser.add_argument("url", help="Bitbucket PR URL")
    parser.add_argument(
        "--no-diff", action="store_true", help="Skip fetching the diff"
    )
    parser.add_argument(
        "--diff-only", action="store_true", help="Only print the diff"
    )
    args = parser.parse_args()

    project, repo, pr_id = parse_pr_url(args.url)

    if not args.diff_only:
        pr = api_get_json(
            f"/projects/{project}/repos/{repo}/pull-requests/{pr_id}"
        )
        print_frontmatter(pr)
        print_comments(project, repo, pr_id)

    if not args.no_diff:
        if not args.diff_only:
            print("-" * 72)
            print("DIFF")
            print("-" * 72)
        diff = get_diff(project, repo, pr_id)
        print(diff)


if __name__ == "__main__":
    main()
