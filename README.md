# PyCBCInferenceWorkshopMay2019
Repository for the PyCBC Inference workshop in Portsmouth, UK, 14 May - 16 May 2019.

This repository contains all of the tutorials and talks that were presented at the workshop; it provides a good introduction to PyCBC Inference, and Bayesian inference in general. We recommend following the [Program](https://github.com/gwastro/PyCBCInferenceWorkshopMay2019/wiki/Program). The links listed there link to the tutorials/lectures in this repository.

## How to run the tutorials
### Using SciServer
To run the tutorials, we recommend using [SciServer](https://apps.sciserver.org):
  1. If you don't already have one, create a SciServer account (it's free). Then go to https://apps.sciserver.org/compute/.
  2. Click "Create container". Give it a name; in the "Compute Image" drop-down menu click "Python + R". Then click "Create."
  3. Click on the container you just created; this will open a new tab in your browser that is a Jupyter notebook interface.
  4. Clone this repository into your SciServer container: Click "New" -> "Terminal". This will open another tab that with a bash terminal in it. Change directory into "workspace" by typing `cd workspace`. Now type:
     ```
     git clone https://github.com/gwastro/PyCBCInferenceWorkshopMay2019.git
     ```
     This will download a copy of this repository to your directory on SciServer.
  5. Go back to your tab with the Jupyter notebook. Click on the "PyCBCInferenceWorkshopMay2019" directory. From there you can navigate to the tutorial you want to view (using the [Program]((https://github.com/gwastro/PyCBCInferenceWorkshopMay2019/wiki/Program) as a guide. When you click on a tutorial (files that end in `.ipynb`), a new tab will open with tutorial open in it. All of the code needed is installed at the beginning of the tutorials.

### Using a package manager on your local computer
Alternatively, if you prefer to run things on your local computer, create an environment to run in using your favorite package manager (e.g., conda, virtualenv) and install jupyter into it (e.g., `pip install jupyter`). Then clone the repository using the above command.
