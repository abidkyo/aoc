// -----------------------------------------------------------------------------

const std = @import("std");

const expect = std.testing.expect;

pub fn isSequenceRepeated(num: usize) bool {
    std.debug.assert(num <= 9_999_999_999);
    return switch (num) {
        10...99 => num % 11 == 0,
        100...999 => num % 111 == 0,
        1_000...9_999 => num % 101 == 0 or num % 1_111 == 0,
        10_000...99_999 => num % 11_111 == 0,
        100_000...999_999 => num % 1_001 == 0 or num % 10_101 == 0 or num % 111_111 == 0,
        1_000_000...9_999_999 => num % 1_111_111 == 0,
        10_000_000...99_999_999 => num % 10_001 == 0 or num % 1_010_101 == 0 or num % 11_111_111 == 0,

        100_000_000...999_999_999 => num % 1_001_001 == 0 or num % 111_111_111 == 0,
        1_000_000_000...9_999_999_999 => num % 100_001 == 0 or num % 101_010_101 == 0 or num % 1_111_111_111 == 0,
        else => false,
    };
}

test isSequenceRepeated {
    try expect(isSequenceRepeated(11));
    try expect(!isSequenceRepeated(12));

    try expect(isSequenceRepeated(111));
    try expect(!isSequenceRepeated(121));

    try expect(isSequenceRepeated(121212));
    try expect(!isSequenceRepeated(122112));

    try expect(isSequenceRepeated(123123123));
    try expect(!isSequenceRepeated(123321123));
}

pub fn isSequenceRepeatedTwice(num: usize) bool {
    std.debug.assert(num <= 9_999_999_999);
    return switch (num) {
        10...99 => num % 11 == 0,
        1_000...9_999 => num % 101 == 0,
        100_000...999_999 => num % 1_001 == 0,
        10_000_000...99_999_999 => num % 10_001 == 0,
        1_000_000_000...9_999_999_999 => num % 100_001 == 0,
        else => false,
    };
}

test isSequenceRepeatedTwice {
    try expect(isSequenceRepeatedTwice(11));
    try expect(!isSequenceRepeatedTwice(111));

    try expect(isSequenceRepeatedTwice(1111));
    try expect(!isSequenceRepeatedTwice(11111));

    try expect(isSequenceRepeatedTwice(1212));
    try expect(!isSequenceRepeatedTwice(121212));

    try expect(isSequenceRepeatedTwice(123123));
    try expect(!isSequenceRepeatedTwice(123123123));
}

// EOF -------------------------------------------------------------------------
