# ECD #

Implementation of "Evolutionary Community Detection in Dynamic Social Networks".

If you find this method helpful for your research, please cite this paper.

    @INPROCEEDINGS{8852006, 
    	author = {Fanzhen Liu and Jia Wu and Chuan Zhou and Jian Yang},
    	booktitle = {2019 International Joint Conference on Neural Networks (IJCNN)},
    	title = {Evolutionary Community Detection in Dynamic Social Networks},
    	year = {2019},
    	pages = {1-7},
    	doi = {10.1109/IJCNN.2019.8852006}
    }


----------

**Requirement**

- Matlab >= 2013a

----------

**Datasets**

Datasets used in this paper can be obtain from the original sources.

<table>
   <tr>
      <th colspan="2">Dataset</th>
      <th>Source</th>
   </tr>
   <tr>
      <td style="text-align:center" width="12%" rowspan="3" >Synthetic datasets</td>
      <td style="text-align:center" width="13%" >SYN-FIX</td>
      <td rowspan="2" >M.-S. Kim and J. Han, “A particle-and-density based evolutionary clustering method for dynamic networks,” Proc. VLDB Endow., vol. 2, no. 1, pp. 622–633, 2009.</td>
   </tr>
   <tr>
      <td style="text-align:center" >SYN-VAR</td>
   </tr>
   <tr>
      <td style="text-align:center">SYN-EVENT</td>
      <td>D. Greene, D. Doyle, and P. Cunningham, “Tracking the evolution of communities in dynamic social networks,” in Proc. Int. Conf. Adv. Soc. Netw. Anal. Min. (ASONAM), pp. 176–183, 2010.</td>
   </tr>
   <tr>
      <td style="text-align:center" rowspan="2" >Real-world datasets</td>
      <td style="text-align:center" >Cellphone Calls</td>
      <td>http://www.cs.umd.edu/hcil/VASTchallenge08/</td>
   </tr>
   <tr>
      <td style="text-align:center" >Enron Mail</td>
      <td>http://www.cs.cmu.edu/~enron/</td>
   </tr>
</table>

---------

**How to use**

Before run the `run_ECD.m`, please choose a network to load and properly set corresponding parameters in the `run_ECD.m`. Please see the content in `run_ECD.m` for more information.

The `W_Cube.mat` records the adjacent matrices of a dynamic network in several time steps, the `GT_Cube.mat` or `GT_Matrix.mat` records the ground truth community structures of a synthetic network in all time steps. For Real-world networks without ground truth community structures, the `firststep_DYNMOGA_cell.mat` and `firststep_DYNMOGA_enron.mat` record the community structures detected by the first step of DYNMOGA (Folino and Pizzuti 2014) in all timesteps as the ground truth community structures.

Finally, `ECD_Result` records the community structures detected by ECD in all time steps; `DynMod` and `DynNmi` record the modularity of the detected community structure at each time step and the NMI that measures the similarity between a detected community structure and the ground truth at each time step, respectively.  

----------

**Disclaimer**

If you find any bugs, please report them to me.
