//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <numeric>
// UNSUPPORTED: c++03, c++11, c++14
// UNSUPPORTED: clang-8

// Became constexpr in C++20
// template<class InputIterator>
//     typename iterator_traits<InputIterator>::value_type
//     reduce(InputIterator first, InputIterator last);

#include <numeric>
#include <cassert>

#include "test_macros.h"
#include "test_iterators.h"

template <class Iter, class T>
TEST_CONSTEXPR_CXX20 void
test(Iter first, Iter last, T x)
{
    static_assert( std::is_same_v<typename std::iterator_traits<decltype(first)>::value_type,
                                decltype(std::reduce(first, last))> );
    assert(std::reduce(first, last) == x);
}

template <class Iter>
TEST_CONSTEXPR_CXX20 void
test()
{
    int ia[] = {1, 2, 3, 4, 5, 6};
    unsigned sa = sizeof(ia) / sizeof(ia[0]);
    test(Iter(ia), Iter(ia), 0);
    test(Iter(ia), Iter(ia+1), 1);
    test(Iter(ia), Iter(ia+2), 3);
    test(Iter(ia), Iter(ia+sa), 21);
}

template <typename T>
TEST_CONSTEXPR_CXX20 void
test_return_type()
{
    T *p = nullptr;
    static_assert( std::is_same_v<T, decltype(std::reduce(p, p))> );
}

TEST_CONSTEXPR_CXX20 bool
test()
{
    test_return_type<char>();
    test_return_type<int>();
    test_return_type<unsigned long>();
    test_return_type<float>();
    test_return_type<double>();

    test<cpp17_input_iterator<const int*> >();
    test<forward_iterator<const int*> >();
    test<bidirectional_iterator<const int*> >();
    test<random_access_iterator<const int*> >();
    test<const int*>();

    return true;
}

int main(int, char**)
{
    test();
#if TEST_STD_VER > 17
    static_assert(test());
#endif
    return 0;
}
