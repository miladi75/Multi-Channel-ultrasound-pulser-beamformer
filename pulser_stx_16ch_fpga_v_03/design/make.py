
#!/usr/bin/python
# PYTHON_ARGCOMPLETE_OK
import os, sys
import subprocess
import random
# import argcomplete, argparse

#--------------------------------------#
#---- set constants and parameters ----#
#--------------------------------------#
os.system('echo make.py args: ' + str(sys.argv[1:]))

# Run options: targets. The dictionary 'dependencies' contains information about what is executed for the chosen target.
targets = ['all','prepare','lint','compile','rbf','create_dist','report','check_timing','clean','quartus','jenkins']

# Parameters
BRANCH     = os.getcwd().split('/')[-1].split('-')[-1].split(' ')[-1]
CORES      = 4
TIMING     = 'true'   # compile until timing is met
SEED       = 1
TESTNUM    = 4        # build TESTNUM times to see how many of them fails timing
EFFORT     = 2        # Fitting effort
LINT       = 'false'
TEST_IMG   = 'true'
WSB_TEST   = 'false'
SFI_REGBUF = 'false'
IMG_TYPE   = None    # app: application, fac: factory image, build both if None (fac 1st)

# Set target
if (len(sys.argv) > 1) and (sys.argv[1] in targets+['test']):
    target = sys.argv[1]
    args   = sys.argv[2:]
else:
    target = 'all'
    args   = sys.argv[1:]
os.system('echo target: %s' % target)


PROJECT   = 'pulser_stx_16ch_fpga'
PARTNO    = 'cyc5gx'
FPGA_NAME = PARTNO.split('_')[-1]

REPO_ROOTDIR = os.path.dirname(os.path.realpath(__file__))[:-7].replace(' ', '\\ ')
DESIGNDIR    = REPO_ROOTDIR + '/design'


QUARTUS_ROOTDIR  = '/home/seyedh/intelFPGA_lite/23.1std/quartus'
EMBEDDED_ROOTDIR = '/home/seyedh/intelFPGA_lite/23.1std/embedded'

QUARTUS_OPT = '--64bit' if (sys.maxsize > 2**32) else ''

QUARTUS_SH  = QUARTUS_ROOTDIR + '/bin/quartus_sh  %s'  % QUARTUS_OPT
QUARTUS_CPF = QUARTUS_ROOTDIR + '/bin/quartus_cpf %s' % QUARTUS_OPT
QUARTUS_PGM = QUARTUS_ROOTDIR + '/bin/quartus_pgm %s' % QUARTUS_OPT
QUARTUS_MAP = QUARTUS_ROOTDIR + '/bin/quartus_map %s' % QUARTUS_OPT
QUARTUS_CDB = QUARTUS_ROOTDIR + '/bin/quartus_cdb %s' % QUARTUS_OPT
QUARTUS_FIT = QUARTUS_ROOTDIR + '/bin/quartus_fit %s' % QUARTUS_OPT
QUARTUS_ASM = QUARTUS_ROOTDIR + '/bin/quartus_asm %s' % QUARTUS_OPT
QUARTUS_STA = QUARTUS_ROOTDIR + '/bin/quartus_sta %s' % QUARTUS_OPT
QUARTUS_GUI = QUARTUS_ROOTDIR + '/bin/quartus %s'     % QUARTUS_OPT

CPF_OPT_RBF = '-c -o bitstream_compression=on'
CPF_OPT_JIC = '-c {PROJECT}%s.cof'.format(PROJECT=PROJECT)
MK_OPTION   = '-A arm -T firmware -C none -O u-boot -a 0 -e 0 -n "RBF"'
MAP_OPTION  = '--read_settings_files=on --write_settings_files=off'
FIT_OPTION  = MAP_OPTION
CDB_OPTION  = '--read_settings_files=off --write_settings_files=off --merge=on'

# GITTAG     = subprocess.check_output('git rev-parse --short=8 HEAD', shell=True)[:-1]
GITTAG     = 'gittag'
BUILD_ID_I = subprocess.check_output('date +"%y-%m-%d_%H-%M-%S"', shell=True)[:-1]
BUILD_ID   = 'xxx'

#----------- Parse parameters -----------#
for arg in args:
    var = arg.split('=')[0].upper()
    val = arg.split('=')[1]
    try:
        # numbers
        globals()[var] = int(val)

    except ValueError:
        # strings
        globals()[var] = val
    except:
        pass

BUILDDIR     = DESIGNDIR + '/build'
BUILDDIR_APP = DESIGNDIR + '/build_app'
BUILDDIR_FAC = DESIGNDIR + '/build_fac'

REV_ID       = '%s_%s_%s_%s_%s' % (PARTNO, 'tbd_imtype', BRANCH, BUILD_ID, GITTAG)
RBF_NAME     = '%s_%s_%s_%s_%s' % (PARTNO, 'tbd_imtype', BRANCH, BUILD_ID, GITTAG)


NAME         = '%s_%s_%s_%s_%s' % (PARTNO, BRANCH, BUILD_ID, GITTAG, BUILD_ID_I)
DISTFOLDER   = DESIGNDIR + '/dist/' + NAME

#----------- Misc functions -----------#
def check_sof(img_type='app'):
    soffile = '{BUILDDIR}_{IMTYPE}/{PROJECT}.sof'.format(BUILDDIR=BUILDDIR, IMTYPE=img_type, PROJECT=PROJECT)
    if not os.path.isfile(soffile):
        os.system("echo '%s' not found. Run make quartus to build the design" % soffile)
        return 1

def neg_slack(img_type='app'):
    try:
        timereport = BUILDDIR + "_%s/%s.sta.summary" % (img_type, PROJECT)
        print('Evaluating timing report:')
        print(timereport)
        with open(timereport, 'r') as f:
            for line in f.readlines():
                if "Slack : -" in line:
                    return 1
        return 0
    except Exception as e:
        print(e)
        return 2

def run_dependencies(dependencies, img_type):
    """ Runs the functions whose names are
        specified in the dependencies list
    """
    if len(dependencies):
        for dep in dependencies:
            if img_type == 'fac' and dep == 'report':
                continue

            if dep in ['report']:
                globals()[dep]()
            else:
                globals()[dep](img_type)

def run_shell_cmd(cmd):
    """ Runs shell command and raises
        error if it failed.
    """
    try:
        subprocess.check_call(cmd, shell=True)
    except subprocess.CalledProcessError:
        os.system("echo Error while running command: %r" % cmd)
        if 'quartus_fit' not in cmd:
            sys.exit()


#---------------------------------------#
#------------- Run options -------------#
#---------------------------------------#
def prepare(img_type='app'):
    rev_id   = REV_ID.replace('tbd_imtype', img_type)
    rbf_name = RBF_NAME.replace('tbd_imtype', img_type)
    build_folder = BUILDDIR + '_' + img_type

    if IMG_TYPE is None and img_type=='app':
        clean(rm_build=False)

    os.system('echo')
    os.system('echo Preparing %s image' % ('APPLICATION' if img_type=='app' else 'FACTORY'))
    os.system('echo')
    os.system('echo REV_ID    : %s' % rev_id)
    os.system('echo RBF_NAME  : %s' % rbf_name)
    os.system('echo DISTFOLDER: %s' % DISTFOLDER)
    os.system('echo TEST_IMG  : %s' % TEST_IMG)

    if not os.path.isfile('{BUILDDIR}/mapping_done'.format(BUILDDIR=build_folder)):
        if not os.path.isfile('{DESIGNDIR}/{PROJECT}.qsf'.format(DESIGNDIR=DESIGNDIR, PROJECT=PROJECT)):
            os.system('echo;echo Running prepare;echo')

            runcmd="cd {DESIGNDIR};\
                       {QUARTUS_SH} -t {PROJECT}.tcl {CORES}".format(QUARTUS_SH = QUARTUS_SH,
                                                                     DESIGNDIR  = DESIGNDIR,
                                                                     PROJECT    = PROJECT,
                                                                     CORES      = CORES)
            run_shell_cmd(runcmd)

            tcl_params = '{REV_ID} {SEED} {EFFORT} {TEST_IM} {WSB_TEST} {IMTYPE} {SFI_REGBUF}'.format(REV_ID     = rev_id,
                                                                                                      SEED       = SEED,
                                                                                                      EFFORT     = EFFORT,
                                                                                                      TEST_IM    = TEST_IMG,
                                                                                                      WSB_TEST   = WSB_TEST,
                                                                                                      IMTYPE     = img_type,
                                                                                                      SFI_REGBUF = SFI_REGBUF)
            runcmd="cd {DESIGNDIR};\
                       {QUARTUS_SH} -t build_settings.tcl {tcl_params}".format(DESIGNDIR  = DESIGNDIR,
                                                                               QUARTUS_SH = QUARTUS_SH,
                                                                               tcl_params = tcl_params)
            run_shell_cmd(runcmd)
        else:
            os.system('echo Skipping preparing, because design/{PROJECT}.qsf exists'.format(PROJECT=PROJECT))
    else:
        os.system('echo Skipping preparing, because {BUILDDIR}/mapping_done exists'.format(BUILDDIR=build_folder))

def lint(img_type='app'):
    build_folder = BUILDDIR + '_' + img_type

    if LINT == "false":
        os.system('echo Skipping lint check due to user request.')
        os.system('mkdir -p {BUILDDIR}'.format(BUILDDIR=build_folder))
        os.system('touch {BUILDDIR}/linting_done'.format(BUILDDIR=build_folder))
        return

    if not os.path.isfile('{BUILDDIR}/linting_done'.format(BUILDDIR=build_folder)):
        os.system('echo;echo Running lint;echo')
        # 1) Create project from Quartus project
        alint_console_binary = subprocess.check_output('locate runalintprocon', shell=True)[:-1].decode()

        runcmd='cd {DESIGNDIR};\
                {runalintprocon} -batch -do convert.qpf.project {PROJECT}.qpf;'.format(DESIGNDIR      = DESIGNDIR,
                                                                                       runalintprocon = alint_console_binary,
                                                                                       PROJECT        = PROJECT)
        run_shell_cmd(runcmd)

        # 2) Set generics (the project conversion yields unreliable values)
        with open(DESIGNDIR + '/%s.qsf' % PROJECT, 'r') as qsffile:
            generics = ''
            for line in qsffile.readlines():
                if line.startswith('set_parameter -name G_'):
                    g_name  = line.split(' ')[2]
                    g_value = line.split(' ')[3].replace('\n', '')
                    generics += '-generic {%s=%s} ' % (g_name, g_value)

        alint_policy_file = 'project_policy.do'
        if not os.path.isfile(DESIGNDIR + '/ALINT-PRO/%s' % alint_policy_file):
            os.system("echo Skipping linting, because design/ALINT-PRO/%s does not exist." % alint_policy_file)
        else:
            with open(DESIGNDIR + '/ALINT-PRO/temp_alint.do','w') as dofile:
                dofile.write('workspace.open {PROJECT}.alintws\n'.format(PROJECT = PROJECT))
                dofile.write('workspace.project.setactive -project {FPGA}\n'.format(FPGA = FPGA_NAME))
                dofile.write('project.clean -project {FPGA}\n'.format(FPGA = FPGA_NAME))
                dofile.write('project.pref.generics -project {FPGA} {GENERICS}\n'.format(FPGA     = FPGA_NAME,
                                                                                         GENERICS = generics))
                dofile.write('project.import.policy -file {POL_FILE}\n'.format(POL_FILE = alint_policy_file))

            runcmd='cd {DESIGNDIR}/ALINT-PRO;\
                    {runalintprocon} -batch -do temp_alint.do;'.format(DESIGNDIR      = DESIGNDIR,
                                                                       runalintprocon = alint_console_binary)
            run_shell_cmd(runcmd)

            # 3) Run project
            with open(DESIGNDIR + '/ALINT-PRO/run_alint.do','w') as runalintfile:
                runalintfile.write('workspace.open {PROJECT}.alintws\n'.format(PROJECT = PROJECT))
                runalintfile.write('project.run -project {FPGA}\n'.format(FPGA = FPGA_NAME))
                runalintfile.write('project.report.violations -format html -report alint_output/reports/html_violations_report.html\n')
                runalintfile.write('project.report.quality -format html -report alint_output/reports/design_quality_report.html\n')
                runalintfile.write('project.report.violations -format csv -report alint_output/reports/csv_violations_report.csv\n')

            runcmd='cd {DESIGNDIR}/ALINT-PRO;\
                    {runalintprocon} -batch -do run_alint.do;'.format(DESIGNDIR      = DESIGNDIR,
                                                                      runalintprocon = alint_console_binary)
            run_shell_cmd(runcmd)

            # 4) Summarize number of violations
            try:
                num_violations = len(open(DESIGNDIR+'/ALINT-PRO/alint_output/reports/csv_violations_report.csv').readlines(  )) - 1
                with open(DESIGNDIR+'/ALINT-PRO/alint_output/reports/num_of_violations.csv', 'w') as f:
                    f.write('Number_of_violations\n')
                    f.write('%d\n' % num_violations)
                # 5) Done
                os.system('mkdir -p {BUILDDIR}'.format(BUILDDIR=build_folder))
                os.system('touch {BUILDDIR}/linting_done'.format(BUILDDIR=build_folder))

            except IOError:
                os.system('echo Linting error'.format(BUILDDIR=BUILDDIR))

    else:
        os.system('echo Skipping linting, because {BUILDDIR}/linting_done exists'.format(BUILDDIR=build_folder))

def compile(img_type='app'):
    build_folder = BUILDDIR + '_' + img_type
    if not os.path.isfile('{BUILDDIR}/compile_done'.format(BUILDDIR=build_folder)):
        runcmd='cd {DESIGNDIR};\
                   {QUARTUS_SH} --flow compile {PROJECT};'.format(DESIGNDIR  = DESIGNDIR,
                                                                  QUARTUS_SH = QUARTUS_SH,
                                                                  PROJECT    = PROJECT)
        run_shell_cmd(runcmd)

        os.system('touch {BUILDDIR}/compile_done'.format(BUILDDIR=build_folder))
    else:
        os.system('echo Skipping compilation, because {BUILDDIR}/compile_done exists'.format(BUILDDIR=build_folder))

def rbf(img_type='app'):
    build_folder = BUILDDIR + '_' + img_type
    if check_sof(img_type):
        missing_sof = 'application' if img_type=='app' else 'factory'
        sys.exit()
    else:
        os.system('echo Generating unencrypted RBF image...')
        runcmd='cd {DESIGNDIR};\
                   {QUARTUS_CPF} {CPF_OPTION} {BUILDDIR}/{PROJECT}.sof {BUILDDIR}/{PROJECT}.rbf'.format(DESIGNDIR   = DESIGNDIR,
                                                                                                        BUILDDIR    = build_folder,
                                                                                                        QUARTUS_CPF = QUARTUS_CPF,
                                                                                                        CPF_OPTION  = CPF_OPT_RBF,
                                                                                                        PROJECT     = PROJECT)
        run_shell_cmd(runcmd)

def jic(img_type='app'):
    build_folder = BUILDDIR + '_' + img_type

    if IMG_TYPE is None and img_type == 'full':
        error = check_sof('app') or check_sof('fac')
    else:
        error = check_sof(img_type)

    if error:
        sys.exit()
    else:
        insert_str = '_%s' % img_type
        cpf_option = CPF_OPT_JIC % insert_str
        os.system('echo cpf_option : %s' % cpf_option)
        os.system('echo Generating JIC and RPD images...')
        runcmd='cd {DESIGNDIR};\
                   {QUARTUS_CPF} {CPF_OPTION}'.format(DESIGNDIR   = DESIGNDIR,
                                                      QUARTUS_CPF = QUARTUS_CPF,
                                                      CPF_OPTION  = cpf_option)
        run_shell_cmd(runcmd)

# def report():
#     if os.path.isfile('{BUILDDIR}/{PROJECT}.fit.summary'.format(BUILDDIR = BUILDDIR_APP,
#                                                                 PROJECT  = PROJECT)):
#         os.system('cd {DESIGNDIR} && \
#                    python parse_reports.py;\
#                    python parse_fitreport.py;\
#                    python parse_timingreport.py;\
#                    python parse_fitmessages.py;\
#                    python parse_mapmessages.py;\
#                    python parse_timemessages.py'.format(DESIGNDIR=DESIGNDIR))

def create_dist(img_type='app'):
    build_folder = BUILDDIR + '_' + img_type
    os.system("printf '\n Creating the distribution package \n'")

    if IMG_TYPE is None:        # both image types
        img_type_list = ['fac', 'app', 'full']

        if img_type == 'fac':   # factory image is built first, skip in this case
            return
        else:
            if check_sof('fac'):
                os.system("echo File '{BUILDDIR}/{PROJECT}.sof' not found. Run make to build the design!".format(BUILDDIR=BUILDDIR_FAC, PROJECT=PROJECT))
                sys.exit()
            elif check_sof('app'):
                os.system("echo File '{BUILDDIR}/{PROJECT}.sof' not found. Run make to build the design!".format(BUILDDIR=BUILDDIR_APP, PROJECT=PROJECT))
                sys.exit()

            jic('full')
    else:
        if check_sof(img_type):
            os.system("echo File '{BUILDDIR}/{PROJECT}.sof' not found. Run make to build the design!".format(BUILDDIR=build_folder, PROJECT=PROJECT))
            sys.exit()

        img_type_list = [img_type]

    for imtype in img_type_list:
        build_folder = BUILDDIR + '_' + imtype
        rbf_name     = RBF_NAME.replace('tbd_imtype', imtype)

        if imtype != 'full':
            os.system('\
                mkdir -p {DISTFOLDER}/reports;\
                cp {BUILDDIR}/{PROJECT}.sof {DISTFOLDER}/{RBF_NAME}.sof;\
                cp {BUILDDIR}/*.rpt {DISTFOLDER}/reports'.format(DISTFOLDER = DISTFOLDER,
                                                                 BUILDDIR   = build_folder,
                                                                 PROJECT    = PROJECT,
                                                                 RBF_NAME   = rbf_name))
        else:
            pass

        os.system('\
            cp {DESIGNDIR}/{PROJECT}_{IMTYPE}.jic {DISTFOLDER}/{RBF_NAME}.jic;\
            cp {DESIGNDIR}/{PROJECT}_{IMTYPE}_auto.rpd  {DISTFOLDER}/{RBF_NAME}.rpd;'.format(DISTFOLDER = DISTFOLDER,
                                                                                             BUILDDIR   = build_folder,
                                                                                             PROJECT    = PROJECT,
                                                                                             DESIGNDIR  = DESIGNDIR,
                                                                                             IMTYPE     = imtype,
                                                                                             RBF_NAME   = rbf_name))
    # create zip
    os.system('\
        git log > {DISTFOLDER}/ChangeLog;\
        cd {DESIGNDIR}/dist; zip -r {NAME}.zip {NAME}'.format(DISTFOLDER = DISTFOLDER,
                                                              DESIGNDIR  = DESIGNDIR,
                                                              NAME       = NAME))

def check_timing(img_type='app'):
    build_folder = BUILDDIR + '_' + img_type

    if os.path.isfile('{BUILDDIR}/compile_done'.format(BUILDDIR=build_folder)):
        os.system('echo checking timing')
        result = neg_slack(img_type)

        if result:
            if result == 1:
                os.system('echo negative slack found')

            return 1
        else:
            os.system('echo all slack is positive')
            os.system('touch {BUILDDIR}/timing_OK'.format(BUILDDIR=build_folder))
            return 0
    else:
        os.system('echo Omitting timing check, because compilation did not run properly (compile_done file not found). Exiting.')
        sys.exit()

def clean(rm_build=True):
    os.system('echo Cleaning up.')
    if IMG_TYPE is None:
        builddirs = 'build_app build_fac'
    else:
        builddirs = 'build_%s' % IMG_TYPE

    if rm_build:
        targets_to_remove = '{BUILDDIRS} {PROJECT}.qsf db incremental_db greybox_tmp plot_data'.format(BUILDDIRS = builddirs,
                                                                                                       PROJECT   = PROJECT)
    else:
        targets_to_remove = '{PROJECT}.qsf db incremental_db greybox_tmp plot_data'.format(PROJECT = PROJECT)

    os.system('echo Removing the following from design folder:;\
               echo %s' % targets_to_remove)
    os.system('cd {DESIGNDIR};\
               rm -rf {TOBEREMOVED}'.format(TOBEREMOVED = targets_to_remove,
                                            DESIGNDIR   = DESIGNDIR))
    # Get rid of Alint files, except for project_policy.do
    if os.path.isdir('{DESIGNDIR}/ALINT-PRO'.format(DESIGNDIR = DESIGNDIR)):
        os.system("cd {DESIGNDIR}/ALINT-PRO;\
                   ls -A | grep -v project_policy.do | xargs rm -rf".format(DESIGNDIR = DESIGNDIR))
    os.system("echo AAAND IT\\'S GONE.")

def all():
    os.system("printf '\n Full compilation finished.\n'")

#------------- Build functions -------------#
def build_no_timing(target, img_type='app'):  # Don't care about timing
    run_dependencies(dependencies[target], img_type)
    try:
        try:
            locals()[target](img_type)
        except KeyError:
            globals()[target](img_type)

    except Exception as e:
        print(e)
        try:
            locals()[target]()
        except KeyError:
            globals()[target]()

def build_until_timing_met(target, img_type='app'):
    global SEED
    build_folder = BUILDDIR + '_' + img_type

    num_of_runs = 0
    while not os.path.isfile('{BUILDDIR}/timing_OK'.format(BUILDDIR=build_folder)):
        num_of_runs += 1
        run_dependencies(dependencies['check_timing'], img_type)

        if os.path.isfile('{BUILDDIR}/compile_done'.format(BUILDDIR=build_folder)):

            if check_timing(img_type):

                SEED = int(SEED) + 1
                os.system("echo Timing is violated. Recompiling with new SEED: %d" % SEED)
                os.system('rm {BUILDDIR}/compile_done'.format(BUILDDIR=build_folder))
                os.system("notify-send '{summary}' -a '{title}' -t 1 '{message}'".format(summary = 'Timing FAILED',
                                                                                         title   = '',
                                                                                         message = 'new seed: %d' % SEED ))

            else:
                os.system("echo Timing is OK with SEED: %d" % SEED)
        else:
            os.system("echo Error while building image. Retrying.")

    if os.path.isfile('{BUILDDIR}/compile_done'.format(BUILDDIR=build_folder)):
        dep = [x for x in dependencies[target] if x not in (dependencies['check_timing'] + ['check_timing'])]
        run_dependencies(dep, img_type)

        # Run function specified with the string in target
        try:
            try:
                locals()[target](img_type)
            except KeyError:
                globals()[target](img_type)
        except:
            try:
                locals()[target]()
            except KeyError:
                globals()[target]()

        os.system("echo Successful build on the %d. run with seed %d." % (num_of_runs, SEED))

    else:
        os.system("echo Error while building image. Exiting.")
        sys.exit()


dependencies = {'prepare'           : [],
                'lint'              : ['prepare'],
                'compile'           : ['prepare', 'lint'],
                'check_timing'      : ['prepare', 'lint', 'compile'],
                'report'            : ['prepare', 'lint', 'compile'],
                'rbf'               : ['prepare', 'lint', 'compile', 'check_timing'],
                'jic'               : ['prepare', 'lint', 'compile', 'check_timing'],
                'create_dist'       : ['prepare', 'lint', 'compile', 'check_timing', 'rbf', 'jic', 'report'],
                'all'               : ['prepare', 'lint', 'compile', 'check_timing', 'rbf', 'jic', 'report', 'create_dist'],
                'quartus'           : ['prepare'],
                'test'              : ['prepare', 'compile', 'check_timing']}

if target in targets:
    if (target in dependencies['all']) or (target == 'all'):                         # targets EXCEPT: clean, quartus and jenkins
        for img_type in ['fac', 'app']:
            if img_type == IMG_TYPE or IMG_TYPE is None:

                if (TIMING == 'true') and ('check_timing' in dependencies[target]):  # in this case build until no timing violations

                    build_until_timing_met(target, img_type)

                else:  # no timing check
                    build_no_timing(target, img_type)

    elif target == 'quartus':  # run for application image
        run_dependencies(dependencies['quartus'], img_type=IMG_TYPE)
        os.system('{QUARTUS_GUI} {DESIGNDIR}/{PROJECT}.qpf'.format(QUARTUS_GUI = QUARTUS_GUI,
                                                                   DESIGNDIR   = DESIGNDIR,
                                                                   PROJECT     = PROJECT))
    elif target == 'jenkins':
        os.system('python {DESIGNDIR}/build.py'.format(DESIGNDIR=DESIGNDIR))

    elif target == 'clean':
        clean()

elif target == 'test':  # run multiple times to see robustness: how many of them meets timing
    failed = 0
    for i in range(TESTNUM):
        run_dependencies(dependencies['check_timing'], img_type='app')

        if check_timing(img_type='app'):
            failed += 1

        SEED = random.randint(1, 2**21)
        clean()

    os.system('echo failed ot of %d: %d' % (TESTNUM, failed))

else:
    os.system("echo Error - Invalid target: %s" % target)


os.system("notify-send '{summary}' -a '{title}' -t 1 '{message}'".format(summary = 'Target: %s finished' % target,
                                                                         title   = '',
                                                                         message = 'seed: %d' % SEED ))
