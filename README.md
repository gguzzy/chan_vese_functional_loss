# Reimagining Image Segmentation using Active Contour

Welcome to the official repository for the paper "Reimagining Image Segmentation using Active Contour: From Chan Vese Algorithm into a Proposal Novel Functional Loss Framework" by Gianluca Guzzetta. This repository contains the MATLAB and PyTorch implementation of the methods discussed in the paper, aimed at advancing the field of image segmentation through the use of a novel functional loss framework based on active contour methods.

## Overview

Image segmentation is a crucial task in computer vision, involving the division of an image into multiple segments to simplify and/or change the representation of an image into something that is more meaningful and easier to analyze. This project utilizes the Chan-Vese active contour modeling method, renowned for its effectiveness in capturing complex object boundaries and operating independently of image intensities.

## Features

- **Chan-Vese Algorithm Implementation**: Detailed MATLAB scripts demonstrating the efficacy of the Chan-Vese method in capturing complex object boundaries.
- **Novel Functional Loss Framework**: Implementation in PyTorch of a new loss function, which incorporates active contour concepts for improved segmentation performance.
- **Comprehensive Documentation**: Detailed explanation of methods, including the level set method and noise introduction techniques for robust image processing.
- **Experimentation and Results**: Contains pre-processed datasets and scripts to reproduce the results discussed in the paper below.



## License
This project is licensed under the MIT License - see the LICENSE.md file for details.

## To-Do List

- [x] **Task 1**: Implement the basic Chan-Vese algorithm in MATLAB for grayscale images.
- [x] **Task 2**: Extend the MATLAB implementation to support RGB images.
- [x] **Task 3**: Develop the PyTorch implementation of the above algorithms using torch and leveraging GPU tensor advantages.
- [ ] **Task 4**: Implement a custom PyTorch loss function and prepare for a pull request submission to `PyTorch/module/losses`.
- [ ] **Task 5**: Create benchmarks using the new PyTorch custom loss.
- [ ] **Task 6**: Compare the results with state-of-the-art (SoAT) custom losses in the PyTorch loss module for image segmentation tasks.

### Suggested Datasets for Benchmarking

For accurate comparisons and benchmarking, consider using the following datasets:
- **PASCAL VOC**: Offers a variety of annotations for image segmentation.
- **Cityscapes**: Focuses on urban scenes and is excellent for evaluating performance on outdoor images.
- **MS COCO**: Provides a wide range of images with complex scenes and multiple object categories, suitable for rigorous testing of segmentation algorithms.

## Installation

Clone this repository to your local machine using:
```bash
git clone https://github.com/gguzzy/cv_functional_loss.git
```

## Citation
If you find this work useful for your research, please cite:

```bibtex
Copy code
@article{guzzetta2023reimagining,
  title={Reimagining Image Segmentation using Active Contour: From Chan Vese Algorithm into a Proposal Novel Functional Loss Framework},
  author={Gianluca Guzzetta},
  journal={GitHub repository, https://github.com/gguzzy/cv_functional_loss},
  year={2024}
}
```

## Contact
For any queries regarding this project, please contact:

Gianluca Guzzetta - s308449@studenti.polito.it
Acknowledgements
This project was developed at Politecnico di Torino. Special thanks to all the collaborators and supporters who contributed to this research.

