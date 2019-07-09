[![Build Status](https://dev.azure.com/personalrobotics/mushr_test/_apis/build/status/colinxs.mushr_test?branchName=master)](https://dev.azure.com/personalrobotics/mushr_test/_build/latest?definitionId=4&branchName=master)

# Environment
Canonical MuSHR environments are hosted as Docker images [here](https://cloud.docker.com/u/personalrobotics/repository/docker/personalrobotics/mushr).

In that repo, see `/dockerfiles/setup_system.sh` to understand how the system is configured. Notably, the available system packages are specified in `dockerfiles/pre_deps.list` and `/dockerfiles/post_deps.list`.

User configuration (installation of Python packages, additional ROS setup, and `.bashrc` configuration) is done in `devtools/setup_user/setup_user.sh`. Similarly, the list of available Python packages is specified in `devtools/setup_user/python2_deps.list`, `devtools/setup_user/python3_deps.list`, and `devtools/setup_user/condapython3_deps.list`. Anaconda and `devtools/setup_user/condapython3_deps.list` exist because the Python code formatter depends on Python 3.6, which is unavailable on the ancient Ubuntu Xenial.

_NOTE:_ Package specific Python packages will be part of your `setup.py` install process. The packages installed by `setup_user.sh` are for basic dependencies.

# Formatting and Linting (Python)

To use these tools, run `setup_user.sh` if you don't already have the required packages. To run the linting tools, you can run them directly, or use the following light wrappers located in `devtools/bin`:

You can optionally create a `lint` conda environment to install the linting tools:
```
$ conda env create -f devtools/lint-env.yaml
$ source activate lint
```
If you don't choose to have a lint environment, you'll have to download the linting tools individually.

Add the linting commands to your path to easily run:
```
# In your ~/.bashrc add:

export PATH=/path/to/devtools/bin:$PATH
```

To run all the tools, run:
```
$ mushr_lint target_dir
```

Format with [black](https://github.com/ambv/black):
```
$ mushr_lint_black target_dir
```

Lint for common problems with [flake8](https://github.com/PyCQA/flake8) (must be run with the same Python version as your package):
```
$ mushr_lint_flake8 target_dir
```

Sort imports properly with [isort](https://github.com/timothycrosley/isort):
```
$ mushr_lint_isort target_dir
```

For black and isort, you can specify the option `check_only` if you only want to test for problems, otherwise code is modified in-place. See each tool's respective documentation on how to integrate them with your workflow (i.e. integrate with Vim or VSCode). Each tool's config file is located in `/devtools/style`.

# Testing (Python)

ROS uses Python's builtin `unittest` and `nose`. `unittest` is extremely verbose (lot's of overhead for test writing), and `nose` is abandonded. Luckily, `nose2` is backwards compatible and even better. See their [docs](https://docs.nose2.io/en/latest/) for info on how to write/run tests. To integrate with Catkin, see [here](http://docs.ros.org/jade/api/catkin/html/howto/format2/python_nose_configuration.html).

# Continuous Integration

To get your repo hooked into Azure Pipelines for CI:

1) Copy [azure-pipelines.yaml](https://github.com/personalrobotics/mushr_python_example/blob/master/azure-pipelines.yml) to the root of your repo.
2) Ask Colin or another Azure Dev Ops Admin to create a Azure Project for your repository (Azure Projects and GitHub Repositories have a 1:1 mapping). Make sure Azure Project private/public setting matches repo setting.
3) Colin or another admin will give you a Markdown snippet for a CI status badge (see the top of the README as an example). Add that snippet as the first line in your package's README.
4) You're done! You'll now see status checks for PRs and the badge will reflect the master branch's build status. Builds will fail if any of black, isort, nose2, or flake8 fail.


# TODO
1. Reflect MuSHR team structure on Azure
2. Move colinxs/mushr_test to personalrobotics/mushr (waiting for structure to stabilize)
3. Add C/C++ example and tooling
4. Add multiple environments (Xenial, Bionic, etc.)
5. rostest
6. Figure out how to add other MuSHR folks to Azure so they can see build status and reasons for failure (not needed if public repo).
