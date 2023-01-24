# Compute TSNE and visualise

Compute and store T-SNE embeddings in `NDIM` under key
`TKEY` of `OUT_HDF5` file; given data stored in `HDF5`
file under keys `XKEY` for inputs (`dtype=float`) and
optionally `YKEY` as labels (`dtype=int`).

Other parameters are as per TSNE-CUDA package (See
https://github.com/CannyLab/tsne-cuda for more
details).
