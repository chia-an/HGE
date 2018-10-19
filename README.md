# Modeling Multi-way Relations with Hypergraph Embedding
This code is for the paper "**Modeling Multi-way Relations with Hypergraph Embedding**," which will be presented in CIKM 2018.

There are two directories:

* **Train_miss_final**: This directory corresponds to Case 1 (Included) in the simulation part, and the algorithms tested include DeepWalk, LINE, HHE, and the proposed method.

* **Train_nomiss_final**: This directory corresponds to Case 2 (Excluded) in the simulation part, and the algorithms tested include MC-AGA, DeepWalk, LINE, HHE, and the proposed method.

### Usage

* Please download the full directory and leave everything as it is (i.e., do not remove any file from the directory).

* In the directory, execute the program files whose names start with "go", and the experimental results presented in the paper can be obtained.

### Acknowledgement
We have adopted the codes in the file **averagePrecisionAtK.m**, authored by **Ben Hanmer**, in **part of the file evaluation.m** in both directories with minor modifications. We appreciate his efforts for the file averagePrecisionAtK.m.

Reference: https://github.com/benhamner/Metrics/blob/master/MATLAB/metrics/averagePrecisionAtK.m
