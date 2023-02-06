import numpy as np, os
import scipy.io as sio
from easydict import EasyDict
import open3d as o3d
from sklearn.neighbors import NearestNeighbors as NN

meshes = []
n = 2
for i in range(n):
    mat = sio.loadmat(f'data/faust/{i}.mat')
    mesh_file = f'/mnt/xrhuang/datasets/dfaust1k_test/ply_orig/{i:03d}.ply'
    mesh = o3d.io.read_triangle_mesh(mesh_file)
    points = np.array(mesh.vertices)
    mesh = EasyDict(dict(
        evals=np.array(mat['Si']['origRes'][0][0]['evals'][0][0]).astype(np.float32),
        evecs=np.array(mat['Si']['origRes'][0][0]['evecs'][0][0]).astype(np.float32),
        points=points,
    ))

    meshes.append(mesh)

os.makedirs('result/faust/matching_from_000', exist_ok=True)
for i in range(1):
    for j in range(i+1, n):
        e0, e1 = sio.loadmat(f'result/faust/matchings/{i:03d}_to_{j:03d}.mat')['matches'].T
        b0 = meshes[i].evecs
        b1 = meshes[j].evecs
        p0 = meshes[i].points
        p1 = meshes[j].points
        print('corres error after', np.linalg.norm(p1[e0] - p1[e1], ord=2, axis=-1).mean())
        tree = NN(n_neighbors=1).fit(p0[e0])
        dists, indices = tree.kneighbors(p0)
        corres = e1[indices[:, 0]]
        print('corres error after', np.linalg.norm(p1 - p1[corres], ord=2, axis=-1).mean())
        with open(f'result/faust/matching_from_000/000_{j:03d}.txt', 'w') as fout:
            for i, c in enumerate(corres):
                fout.write(f'{i} {c}\n')
