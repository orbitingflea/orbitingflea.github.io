---
title: Story of 1-Dimensional Dynamic Succinct Data Structures
date: 2023-08-11T00:00:00.000Z
permalink: /posts/2023/08/1dim-dsds
published: true
tags:
  - data structures
  - story
---

This is a brief introduction to succinct data structures that maintain 1-dim arrays, from the first rank/select algorithm to open problems.

## Pre-Succincter Era

Besides dictionaries, the most basic (and easiest) succinct data structure problems involve maintaining a 1-dim array while supporting certain types of queries, e.g.,
- Rank/select problem: maintain an array $A[1..n]$ of $n$ bits; each query will ask:
  - (rank query) $\sum_{i=1}^n A[i]$;
  - (select query) the position of the $r$-th one in the array.
- Range minimum query (RMQ): maintain an array $A[1..n]$ where each element is an integer in $[U]$, and answer: the minimum value of $A[i..j]$ and/or its position.
- Arithmetic encoding: just maintain an array $A[1..n]$; every query simply asks $A[i]$.
  - Note: this might be nontrivial because the optimal space usage depends on the frequencies of occurrences of elements. E.g., if $A[1..n]$ consists of $0.1n$ zeros and $0.9n$ ones, a succinct data structure must use $\log \binom{n}{0.1n} + o(n)$ bits of space, which forbids you to store elements independently.

In the history, people started with static versions of these problems, which means the array is unchanged during all queries, and we only construct the data structure once at the beginning. The performance of an algorithm is measured by its trade-off between query time and redundancy $R$; in particular, we are interested in the best redundancy we could achieve while keeping the query time constant (optimal).

A very easy example of "succinct rank" structures is the following. We directly store $A[1..n]$ in the memory using $n$ bits, and for every $i$ that is a multiple of $\log^2 n$, we use $\log n$ bits to store the prefix sum $\sum A[1..i]$. The space usage is $n + O(n / \log n)$ bits, but the query time is bad: $O(\log n)$. Implementing this idea carefully will lead to a better solution with $O(n \log \log n / \log n)$-bit redundancy and constant query time.

Similar stories occurred in other mentioned problems. Through some easy ideas, people were able to reduce the redundancy to roughly $n / \log n$, but it was difficult to add more log factors to the denominator. One main reason is that, as long as we want to compress some object $x \in X$ that has $\lvert X \rvert$ different possibilities, we use $\lceil \log \lvert X \rvert \rceil$ bits of space, which immediately wastes 0.5 bits on average, due to rounding up. If people compress the array in some way, they are likely to suffer from the rounding-up wastage; if they do not compress, they suffer from large query time. This stops people from improving succinct data structures for years, until the legendary work [_Succincter_](https://doi.org/10.1109/FOCS.2008.83) by [Mihai Patrascu](https://people.csail.mit.edu/mip/) came up.

Basically, Mihai suggested a generic method to avoid rounding up when we compress or encode information. He obtained the following result (informal):
- If the problem of maintaining a 1-dim array could be solved by an "augmented B-tree (aB-tree)", we can solve it succinctly using $O(n / \text{poly} \log n)$ redundancy and constant time, for an arbitrary $\text{poly} \log n$ factor.
  - **Augmented B-tree** is a B-tree whose internal nodes maintain additional labels, which is similar to a segment tree / range tree / interval tree in competitive programming, but with a larger branching factor.

The functionality of aB-tree is very general, such that this result immediately and significantly improves the redundancy of all listed problems (and many others) to $O(n / \text{poly} \log n)$.

Succincter is a milestone of static succinct data structures. We may think it solves all 1-dim static succinct data structure problems to a reasonably good performance. For some problems (like rank/select), there are known lower bounds that are close to the upper bounds given by Succincter, showing its optimality to some extent. The field of static succinct data structures had changed a lot due to Succincter.

## Dynamic Problems

To be continued.
