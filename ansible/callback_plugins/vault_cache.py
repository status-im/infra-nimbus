import os

from ansible.plugins.callback import CallbackBase
from ansible.utils.display import Display

display = Display()

class CallbackModule(CallbackBase):
    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = 'aggregate'
    CALLBACK_NAME = 'cache_cleanup'

    def __init__(self):
        super(CallbackModule, self).__init__()
        self.cache_dir = "./ansible/files/cache/vault"
        self.cache_file = f"{self.cache_dir}/{os.getpid()}.cache"
        self._create_cache_dir()

    def _create_cache_dir(self):
        """Creates the cache dir if it doesn't exist."""
        try:
            if not os.path.exists(self.cache_dir):
                os.makedirs(self.cache_dir)
                display.v(f"Created cache directory: {self.cache_dir}")
        except Exception as e:
            display.error(f"Failed to create cache dir: {e}")

    def v2_playbook_on_stats(self, stats):
        """Called when the playbook ends, deletes all files in the cache directory."""
        try:
            if os.path.exists(self.cache_dir):
                for filename in os.listdir(self.cache_dir):
                    file_path = os.path.join(self.cache_dir, filename)
                    try:
                        os.remove(file_path)
                        display.v(f"Deleted cache file: {file_path}")
                    except Exception as e:
                        display.error(f"Failed to delete {file_path}: {e}")
        except Exception as e:
            display.error(f"Failed to clean up cache directory: {e}")