import shutil
import re
import os
import sys
import subprocess


VHD_SKU = 'vhd_client_enterprise_en-us_vl'
WINBUILDS_PREFIX = '\\\\winbuilds\\release'
dest=os.path.expanduser('~\\VHDs')
UNATTEND_FILE=os.path.expanduser('~\\VHDs\\unattend-x64.xml')

def help(razzle=True):
	if not razzle:
		print('Command must be run in razzle shell!')
	print('{} [BRANCH REVISION]'.format(sys.argv[0]))

def in_razzle():
	return os.environ.get('SDXROOT') is not None

def get_flavor():
	build_type = os.environ.get('build.type')
	build_arch = os.environ.get('build.arch')
	if not build_type or not build_arch:
		raise ValueError('Bad build environment, need env vars build.type and build.arch')
	return build_arch + build_type


def get_lkg():
	branch_regex = '.* origin/build/(\\w+/[\d\.-]+)'
	cmd = subprocess.run(['findlkg.cmd'], stdout=subprocess.PIPE)
	match = re.match(branch_regex, cmd.stdout.decode('utf8'), flags=re.DOTALL)
	if not match or not match.groups():
		import pdb; pdb.set_trace()
		raise ValueError('Could not find branch info in LKG output: {}'.format(cmd.stdout))
	return match.groups()[0].split('/')

def parse_args():
	assert(len(sys.argv) == 3)
	revision_regex = '[\d\.-]+'
	branch = sys.argv[1]
	revision = sys.argv[2]
	if not branch.startswith('rs'):
		msg = 'Bad branch name: {}'.format(branch)
		print(msg)
		raise ValueError(msg)
	if not re.match(revision_regex, revision):
		msg = 'Bad revision: {}\nShould match: {}'.format(revision, revision_regex)
		print(msg)
		raise ValueError(msg)
	return branch, revision

def mount_winbuilds():
	cmd = subprocess.run(['net.exe', 'use', WINBUILDS_PREFIX], stderr=subprocess.PIPE, stdout=subprocess.PIPE)
	if cmd.returncode != 0:
		raise ValueError('net use failed with exit code {}, message {}'.format(cmd.returncode, cmd.stderr))

def lkg_to_path(branch, revision):
	build_number, build_date = revision.split('.')
	dirs = list(filter(lambda f: f.startswith(build_number) and build_date in f, os.listdir(os.path.join(WINBUILDS_PREFIX, branch))))
	if not dirs:
		raise Exception("Couldn't find a build which matches the LKG {} {}".format(build_number, build_date))
	path = os.path.join(WINBUILDS_PREFIX, branch, dirs[0])
	if not path:
		raise Exception('source vhd doesn\'t  exist, {}, {}, {}'.format(path, branch, revision))
	return path

def copy_to_vhds(path):
	flavor = get_flavor()
	vhd_dir = os.path.join(path, flavor, 'vhd', VHD_SKU)
	vhds = list(filter(lambda x: x.endswith('.vhd'), os.listdir(vhd_dir)))
	if not vhds:
		raise Exception('Could not find vhd :(')
	vhd = os.path.join(vhd_dir, vhds[0])
	dest_vhd = os.path.join(dest, vhds[0])

	if not os.path.exists(dest_vhd):
		print('copying...')
		shutil.copyfile(vhd, dest_vhd)
		print('copied')
	print('Using VHD ', dest_vhd)
	return dest_vhd

def run_ps(cmds, throw_on_error=False):
	script = cmds.replace('\n', ';')
	cmd = subprocess.run(['powershell.exe', '-Command', script], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	if throw_on_error and cmd.returncode:
		raise Exception('Error runing powershell commands: {} exit code: {} stdout: {} stderr: '.format(cmds,
			cmd.returncode, cmd.stdout, cmd.stderr))
	return cmd

def create_vm(vhd):
	name = os.path.basename(vhd)
	if run_ps('Get-VM {}'.format(name)).returncode:
		ps = '''
		New-VM -Name {} -VHDPath {} -SwitchName "Default Switch"
		Start-VM {}
		'''.format(name, vhd, name)
		cmd = run_ps(ps, throw_on_error=True)
		print('Created VM {}'.format(name))
	else:
		print('A VM named {} already exists'.format(name))

def inject_unattend(vhd):
	try:
		ps = '(Mount-VHD -Path "{}" -PassThru | Get-Disk | Get-Partition | Get-Volume).DriveLetter'.format(vhd)
		cmd = run_ps(ps)
		drive_letter = cmd.stdout.decode('utf-8').strip()
		if not drive_letter:
			raise Exception("Error mounting vhd: {}".format(cmd.stderr))
		print('drive letter "{}"'.format(drive_letter))

		drive_unattend = drive_letter + ':\\unattend.xml'
		# FIXME amd64 and x86 should use different unattend files
		shutil.copy(UNATTEND_FILE, drive_unattend)
	finally:
		ps = 'Dismount-VHD -Path "{}"'.format(vhd)
		cmd = run_ps(ps)

def main():
	if not in_razzle():
		help(razzle=False)
		exit(-1)
	if len(sys.argv) == 1:
		print("Getting LKG...")
		branch, revision = get_lkg()
	elif len(sys.argv) == 3:
		branch, revision = parse_args()
	else:
		help()
		exit(-1)
	print('Looking for branch {} revision {}'.format(branch, revision))
	mount_winbuilds()
	print("build: {}/{}".format(branch, revision))
	path = lkg_to_path(branch, revision)
	vhd = copy_to_vhds(path)
	print("VHD {}".format(vhd))
	print("FIXME: inject_unattend broken")
	#inject_unattend(vhd)
	create_vm(vhd)


if __name__ == '__main__':
	try:
		main()
	except Exception as err:
		print(err)
		input('exception thrown, breaking into the debugger, hit enter.')
		import pdb
		pdb.set_trace()
		raise
