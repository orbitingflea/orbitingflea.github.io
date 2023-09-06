---
title: Story of 1-Dimensional Dynamic Succinct Data Structures
date: 2023-08-11T00:00:00.000Z
permalink: /posts/2023/08/1dim-dsds
published: true
tags:
  - data structures
  - story
---

This is a brief introduction to succinct data structures that maintain 1D arrays, from the first rank/select algorithm to open problems.

## Pre-Succincter Era

Besides dictionaries, the most basic (and easiest) succinct data structure problems involve maintaining a 1D array while supporting certain types of queries, e.g.,
- Rank/select problem: maintain an array $A[1..n]$ of $n$ bits; each query will ask:
  - (rank query) $\sum_{i=1}^n A[i]$;
  - (select query) the position of the $r$-th one in the array.
- Range minimum query (RMQ): maintain an array $A[1..n]$ where each element is an integer in $[U]$, and answer: the minimum value of $A[i..j]$ and/or its position.
- Arithmetic encoding: just maintain an array $A[1..n]$; every query simply asks $A[i]$.
  - Note: this might be nontrivial because the optimal space usage depends on the frequencies of occurrences of elements. E.g., if $A[1..n]$ consists of $0.1n$ zeros and $0.9n$ ones, a succinct data structure must use $\log \binom{n}{0.1n} + o(n)$ bits of space, which forbids you to store elements independently.

In the history, people started with static versions of these problems, which means the array is unchanged during all queries, and we only construct the data structure once at the beginning. The performance of an algorithm is measured by its trade-off between query time and redundancy $R$; in particular, we are interested in the best redundancy we could achieve while keeping the query time constant (optimal).

A very easy example of "succinct rank" structures is the following. We directly store $A[1..n]$ in the memory using $n$ bits, and for every $i$ that is a multiple of $\log^2 n$, we use $\log n$ bits to store the prefix sum $\sum A[1..i]$. The space usage is $n + O(n / \log n)$ bits, but the query time is bad: $O(\log n)$ (using the Method of Four Russians). Implementing this idea carefully will lead to a better solution with $O(n \log \log n / \log n)$-bit redundancy and constant query time.

Similar stories occurred in other mentioned problems. Through some easy ideas, people were able to reduce the redundancy to roughly $n / \log n$, but it was difficult to add more log factors to the denominator. One main reason is that, as long as we want to compress some object $x \in X$ that has $\lvert X \rvert$ different possibilities, we use $\lceil \log \lvert X \rvert \rceil$ bits of space, which immediately wastes 0.5 bits on average, due to rounding up. If people compress the array in some way, they are likely to suffer from the rounding-up wastage; if they do not compress, they suffer from large query time. This stops people from improving succinct data structures for years, until the legendary work [_Succincter_](https://doi.org/10.1109/FOCS.2008.83) by [Mihai Patrascu](https://people.csail.mit.edu/mip/) came up.

Basically, Mihai suggested a generic method to avoid rounding up when we compress or encode information. He obtained the following result (informal):
- If the problem of maintaining a 1D array could be solved by an "augmented B-tree (aB-tree)", we can solve it succinctly using $O(n / \text{poly} \log n)$ redundancy and constant time, for an arbitrary $\text{poly} \log n$ factor.
  - **Augmented B-tree** is a B-tree whose internal nodes maintain additional labels, which is similar to a segment tree / range tree / interval tree in competitive programming, but with a larger branching factor.

The functionality of aB-tree is very general, such that this result immediately and significantly improves the redundancy of all listed problems (and many others) to $O(n / \text{poly} \log n)$.

Succincter is a milestone of static succinct data structures. We may think it solves all 1D static succinct data structure problems to a reasonably good performance. For some problems (like rank/select), there are known lower bounds that are close to the upper bounds given by Succincter, showing its optimality to some extent. The field of static succinct data structures had changed a lot due to Succincter.

## Dynamic Problems

Leaving aside the succinctness, most data structure problems are dynamic, in that some kinds of update operations should be supported efficiently. For succinct data structure problems like the few listed above, we also care about the dynamic versions. The easiest type of update is *point updates*, i.e., updating a single element $A[i]$ in the array.

Rank/select with point updates might be the most interesting one. It has another name: fully indexable dictionary, since we can regard the $n$-bit array with $m$ ones as a set of $m$ elements from the universe $[n]$; rank/select queries allow us to find the $k$-th smallest element in the set efficiently, as well as calculating the number of elements smaller than any given $x$.

Prior to 2023, people's understanding of the dynamic rank/select problem remains in the "pre-succincter era", where the best known bound is $O(n / \log n)$ bits of redundancy vs. $O(\log n / \log \log n)$ update/query time. Note that due to known cell-probe lower bounds, the time $O(\log n / \log \log n)$ is optimal even without space constraint, so our goal is usually reducing the redundancy while remaining the optimal operation time.

Easy to imagine, the structure of these $O(n / \log n)$-redundancy algorithms are similar to those static algorithms of the same redundancy. In fact, this is not a coincidence: One straightforward idea of designing dynamic data structures is to keep the storage structure of the static algorithm unchanged, and modify the information according to the update. For example, in our "very easy example" of static rank/select above, we maintained an array of $O(n / \log^2 n)$ integers, each representing a prefix sum of the initial bit-array. When some bit $A[i]$ is updated, we may update all prefix sums on the right of $A[i]$, getting an algorithm with $O(n / \log^2 n)$ update time without thinking. One step further, we may use Fenwick tree or similar structures to maintain the set of prefix sums, which makes both update and query times $O(\log n)$.

Now we know that we can design dynamic data structures by trying to maintain static ones. Then, why not to do similar things on the ultimate hammer, Succincter? We had a paper on this recently (2023), obtaining the following result (informal):
- If the problem of maintaining a 1D array could be solved by an "augmented B-tree (aB-tree)", we can solve it succinctly using $O(n / \text{poly} \log n)$ redundancy and $O(\text{optimal} + \text{poly} \log \log n)$ update/query time, for an arbitrary $\text{poly} \log n$ factor.

Here, $O(\text{optimal})$ means the optimal operation time for the non-succinct version, e.g., it is $O(\log n / \log \log n)$ for rank/select, and $O(\log n)$ if every element in the rank/select problem is a $(\log n)$-bit integer rather than a single bit. The optimal time never exceeds $O(\log n)$ as the whole problem is doable with an aB-tree.

This seems powerful, solving rank/select and RMQ to $O(n / \text{poly} \log n)$ redundancy while remaining the optimal time. However, the last problem in the list, arithmetic coding, is an exception. It naturally has $O(1)$ optimal time even in the dynamic setting, which makes the $O(\text{poly} \log \log n)$ overhead the bottleneck. This remains as an open question:
- **Open Question.** Can we achieve $O(1)$ update/query time and lower (even $O(n / \text{poly} \log n)$) redundancy for arithmetic coding? If not so, is there a lower bound?

Some readers may think the "Dynamic Succincter" technique almost solves all dynamic problems of maintaining 1D arrays as "Succincter" did. Unfortunately, it doesn't. The biggest limiatation of Dynamic Succincter is that it only supports point updates, which does not represent all types of updates. For example, another important type of update is "insertions/deletions", which allows us to remove an element $A[i]$ in the middle or insert a new element in the middle. This is clearly more difficult to maintain than point updates, and the best known redundancy (under optimal time) for rank/select with insertions/deletions is just $O(n \text{ poly} \log \log n / \log^2 n)$.
- **Open Question.** Can we do better for rank/select with insertions and deletions? If not, can we prove a lower bound?

There are also a few open questions regarding optimizing the "Dynamic Succincter" itself instead of downstream applications. However, we are not assuming any familiarity about the Dynamic Succincter (or even Succincter), so it is improper to explain them here.
