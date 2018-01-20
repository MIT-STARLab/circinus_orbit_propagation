import time

# For matlab setup, see http://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html?refresh=true
import matlab
from matlab import engine

MATLAB_OPTIONS = "-nojvm -nodesktop -nosplash -r matlab.engine.shareEngine"
DEFAULT_EXISTING_ENGINE_INDX = -1

class MatlabIF:
    """
    Provides an elegant wrapper around MATLAB python interface functionality

    Tested with MATLAB 2017a, Python 3.5.4

    Note that if new persistent matlab instances are created, clean_up_persistent_engines() should eventually be called to close them. Can be called either in the same python kernel instance, or a subsequent instance. These instances can also be accessed from outside python through the interface of the daemon being used. e.g., "screen -ls; screen -r MATLAB_INSTANCE_NAME"

    See here for general matlab-python usage details: https://www.mathworks.com/help/matlab/matlab-engine-for-python.html
    See here for info about handling data returned from matlab: https://www.mathworks.com/help/matlab/matlab_external/handle-data-returned-from-matlab-to-python.html
    """

    def __init__(self,matlab_ver='MATLAB_R2017a',paths=[],connect=True,use_existing=True,persistent=True):
        self.eng = None
        self.eng_name = None
        self.eng_deleted = False
        self.matlab_ver = matlab_ver

        # to run persistent matlab instances, we'll use screen as a daemon
        self.daemon = 'screen'

        if connect:
            self._connect_matlab_engine(use_existing,persistent)

        if paths:
            self.add_paths(paths)


    def add_paths(self,paths):
        """
        Add paths in which matlab engine should search for scripts

        :param paths: str or list of strings containing path or multiple paths, repspectively
        :return:
        """
        if self.eng:
            if type(paths) is str:
                self.eng.addpath(paths)
            elif type(paths) is list:
                for path in paths:
                    self.eng.addpath(path)

    @staticmethod
    def get_existing_eng_names():
        return matlab.engine.find_matlab()

    @staticmethod
    def delete_matlab_engines(vars_dict):
        for item in vars_dict.items():
            if type(item[1]) == MatlabIF:
                del item.eng
                item.eng_deleted = True

    @staticmethod
    def clean_up_persistent_engines(MatlabIF_instances=[], daemon='screen'):
        """
        Get rid of shared matlab engine instances after greping for their presence in ps -e

        Deletes the eng attribute of existing MatlabIF instances to ensure elegent cleanup, otherwise erroneous errors
        can be produced if MatlabIF objects get reused. Flags those instances with attribute eng_deleted = True

        Note: tried to play nice and use eng.exit() or eng.quit(), but that doesn't seem to work...

        :param list MatlabIF_instances: list with all the MatlabIF instances that have been created in the current python kernel
        :param daemon: daemon used in this interface
        :return:
        """

        if daemon == 'screen':
            # this may work for other daemons too...

            MatlabIF.delete_matlab_engines(MatlabIF_instances)

            from subprocess import Popen, PIPE, call
            import re

            p1 = Popen(["ps","-e"], stdout=PIPE)
            p2 = Popen(["grep","matlab"], stdin=p1.stdout, stdout=PIPE)
            ps_out_lines = str.splitlines(p2.communicate()[0].decode("utf-8"))

            for line in ps_out_lines:
                if MATLAB_OPTIONS in line:
                    pids = re.findall('^[0-9]+', line, re.MULTILINE)

                    if len(pids) > 1:
                        raise Exception('only expected one pid match in this line')
                    else:
                        pid = pids[0]

                    # kill the matlab instance
                    # call(["kill", "-13", pid])
                    Popen(["kill", "-31",pid], stdout=PIPE)

            Popen(["screen", "-wipe"], stdout=PIPE)

        else:
            raise NotImplementedError

    def get_matlab_bin_path(self):
        from sys import platform

        # OS X
        if platform == "darwin":
            return "/Applications/" + self.matlab_ver + ".app/bin/matlab"
        else:
            raise NotImplementedError


    def _start_persistent_shared_matlab(self):
        from os import system
        from datetime import datetime

        previous_sessions_tup = engine.find_matlab()

        if self.daemon == 'screen':
            session_name = 'matlab_' + datetime.utcnow().isoformat()
            # start matlab in detached screen session and run command to share the session
            system('screen -dmS ' + session_name + ' ' + self.get_matlab_bin_path() + " " + MATLAB_OPTIONS)

        # wait till we see a new shared matlab sesh
        new_sessions_tup = engine.find_matlab()
        while (new_sessions_tup == previous_sessions_tup):
            time.sleep(1)
            new_sessions_tup = engine.find_matlab()

        return new_sessions_tup[-1]

    def _connect_matlab_engine(self,use_existing=True,persistent=True):
        """
        Connect to a matlab engine, starting a new one if it hasn't been started yet

        :return:
        """

        found_eng = False
        if use_existing:
            eng_names = engine.find_matlab()
            for eng_name in eng_names:
                try:
                    self.eng = engine.connect_matlab(eng_name)
                    self.eng_name = eng_name
                    found_eng = True

                # unable to connect to an instance because it already has a connection
                except matlab.engine.EngineError:
                    pass

                if found_eng:
                    break

        if not found_eng:
            # if we're making a new persistent engine, create it
            if persistent:
                self.eng_name = self._start_persistent_shared_matlab()
                self.eng = engine.connect_matlab(self.eng_name)

            # otherwise, make a new engine just for the lifetime of self
            else:
                self.eng = engine.start_matlab()
                self.eng_name = None # to be explicit

        self.eng_deleted = False

if __name__ == "__main__":
    mif = MatlabIF(use_existing=True)
    # mif = MatlabIF(use_existing=False,persistent=True)

    # del mif
    # mif = MatlabIF(connect=False)
    # mif.clean_up_persistent_engines()

