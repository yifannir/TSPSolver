# TSPSolver
分层规划的旅行商问题解决方案，采用分层规划的思想，层层聚类，直至最底层单个城市群数量满足一定阈值，然后利用整数规划求最底层城市群的精确解，单层之间的城市群路径规划同样采用整数规划求精确解，这里的城市群路径规划指的是城市群的聚类中心之间的路径规划，最高层为闭合路径的TSP问题，以下单层包括底层都为确定起点终点的不闭合TSP问题，这里的不闭合TSP问题的起点终点贪心的由上一级城市群聚类中心求出的路径来确定哪两个城市群相邻，并由此计算此相邻城市群的最近子城市群对。  求出近似路径后再进行局部的随机优化。
