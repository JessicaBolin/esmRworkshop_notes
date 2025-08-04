---
title: 'R for marine ecologists: wrangling Earth System Model outputs'
tags:
  - R
  - earth system models
  - climate modeling
  - marine ecology 
  - CMIP6
authors:
  - name: Jessica A. Bolin
    orcid: 0000-0002-9868-7511
    affiliation: "1, 2" 
  - name: Mercedes Pozo Buil
    orcid: 0000-0003-3638-271X
    affiliation: 3 
  - name: Nerea Lezama-Ochoa
    orcid: 0000-0003-3106-1669
    affiliation: 3
  - name: Mikaela M. Provost
    affiliation: "1, 2" 
affiliations:
 - name: Coastal and Marine Sciences Institute, University of California, Davis
   index: 1
 - name: Department of Wildlife, Fish, and Conservation Biology,
 University of California, Davis
   index: 2
 - name: Institute of Marine Sciences, University of California, Santa Cruz
   index: 3  
date: 04 August 2025
bibliography: paper.bib
---

# Summary

This one-day, hands-on workshop introduces marine ecologists to the use and application of Earth System Model (ESM) outputs using `R`–a free, open-source programming language widely used in marine ecology. Designed for participants with basic or no prior experience in climate modeling, our workshop: [R for marine ecologists: wrangling Earth System Model outputs](https://jessicabolin.quarto.pub/esmrworkshop_notes/) provides a comprehensive foundation in accessing, processing, and applying ESM outputs for marine ecology applications, by combining theoretical instruction with practical, live-coded sessions. Participants learn to download, regrid, statistically downscale, bias-correct, and visualize sea-surface temperature projections from two Coupled Model Intercomparison Project 6 (CMIP6) models across two climate scenarios. All course materials—including a fully documented Quarto website, annotated `R` scripts, datasets, and a public GitHub repository—are openly available and reusable for both workshop and individual use. Our ultimate goal is to make ESMs more accessible to marine ecologists, and empower the community to incorporate climate projections into their own ecological analyses.

# Statement of Need

As the impacts of climate change on marine ecosystems intensify, there is a growing demand within the marine science community for tools that can integrate climate projections into ecological research. Earth System Models (ESMs), particularly those from the CMIP6 archive, provide essential insights into simulating future climate conditions. The physical oceanography and climate modeling communities have developed robust coding infrastructure and workflows for working with ESMs and gridded ocean data (e.g., typically using MATLAB, Python, and Climate Data Operators (CDO)) [@Irving:2019]. However, these coding platforms are not commonly used within the marine ecology community, where R remains the dominant programming language [@Lai:2019], resulting in a critical skills gap [@Asch:2016; @Halpin:2014]. ESM data, while highly relevant, often remain inaccessible to many marine ecologists due to the technical challenges involved in accessing and difficulty of processing model outputs.

Our workshop is designed to directly address this gap. Our goal is to make ESM data more accessible to marine ecologists by providing the technical expertise needed to work with these complex datasets in R. As such, this workshop is designed around Step 8, “Pre-process the data”, of the proposed workflow for working with ESM outputs described in @Schoeman:2023. The workshop format combines guided theoretical instruction with hands-on, live-coded tutorials that walk participants through downloading, and statistically downscaling (i.e., increasing the spatial and/or temporal resolution of modelled data), bias-correcting (i.e., adjusting model outputs to reduce systematic differences from observed conditions) sea-surface temperature projections from two ESMs within CMIP6, across two climate scenarios. These preprocessing steps are crucial to ensure that model outputs are not only scientifically rigorous, but also ecologically interpretable and appropriate for decision-making at local to regional scales. Our workshop aims to reduce technical barriers and foster capacity-building within the marine ecology community by providing practical and reproducible tools and methods for working with ESM output using R [@Kellie:2023].

# Learning objectives

The learning objectives span seven modules, each targeting a key concept:

1.  Introduction to ESMs (theory)
    1.  What is an ESM, how do they work, what is CMIP6, and how are they used in marine ecological studies?
    2.  Understanding climate scenarios and how to select appropriate models.
2.  Downloading ESM output (theory and live coding)
    1.  Navigating the Earth System Grid Federation (ESGF) website and using shell scripts for downloading ESM data.
    2.  Parallelizing downloads in R.
3.  Regridding and statistically downscaling (live coding)
    1.  Challenges of handling raw ESM spatial data in R.
    2.  Tools and techniques for regridding and downscaling.
4.  Observations (theory and live coding)
    1.  Selecting observational data for bias correction.
    2.  Regridding and downscaling observational datasets.
5.  Bias correction (theory and live coding)
    1.  Importance and methods of bias correction: the delta method.
    2.  Consequences of uncorrected ESM outputs.
    3.  Implementing bias correction with the delta method in R.
6.  Evaluating ESM accuracy (live coding)
    1.  Assessing model accuracy during the observational period.
    2.  Common metrics and visualization approaches.
7.  Making projections (live coding)
    1.  Creating time series of projected SST to 2100.
    2.  Mapping projections across multiple climate scenarios and time periods.

# Experience of use in teaching and learning situations

The initial pilot of the workshop was delivered both in-person and virtually at Bodega Marine Laboratory, California, to a diverse audience including undergraduates, graduate students, postdocs, and researchers. A team of four instructors facilitated teaching, answered questions, and supported technical troubleshooting. Our design leverages worked examples and live coding to facilitate active learning, reduce cognitive load, and mirror real-world workflows. Learners alternate between conceptual grounding and applied exercises, enhancing retention and transfer.

Since the pilot, we have delivered the workshop to other university lab groups and adapted the content for online platforms such as R-Ladies webinars. Participant feedback based on online surveys were positive and have guided continuous improvements to the material. The workshop materials are now also used independently by individuals seeking to build expertise in working with ESM data in R.

# Future directions

Moving forward, we aim to expand the reach of this workshop by (i) translating materials into additional languages, (ii) incorporating more climate variables and modeling scenarios, (iii) partnering with ecological and climate modeling groups globally to broaden access and training opportunities, and (iv) exploring the application of ESMs in marine ecology, such as through species distribution models, using guided examples. We hope that the materials herein can be collaboratively updated and improved (via the associated [Github repository](https://github.com/JessicaBolin/esmRworkshop_notes)) by the marine ecology community.

# How the workshop came to be

Jessica Bolin (Postdoctoral Scholar, University of California Davis) initiated the workshop following a research stay in Monterey, California in collaboration with the UCSC and NOAA Ecosystem group. There, in collaboration with Mercedes Pozo Buil (Associate Project Scientist, University of California Santa Cruz), Mikaela Provost (Assistant Professor, University of California Davis) and Nerea Lezama-Ochoa (Project Scientist, University of California Santa Cruz), conversations highlighted the steep learning curve marine ecologists face when attempting to work with ESM data. These discussions catalyzed the design of our dedicated workshop aimed at closing this skills gap. With financial support from the UC Davis Coastal and Marine Science Institute, we collaboratively developed the pilot workshop and delivered it in June 2025 at Bodega Marine Laboratory, California.

# Acknowledgements

We thank the Coastal and Marine Science Institute (CMSI) of the University of California, Davis for awarding funding to deliver the pilot workshop via their internal grant scheme, in addition to Bodega Marine Laboratory for providing space and facilities. We also thank Barb Muhling, Alice Pidd and Mary Fisher for reviewing workshop code.

# References
