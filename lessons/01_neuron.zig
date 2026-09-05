const std = @import("std");

pub fn main() void {
    // Three input numbers. [3]f32 means an array of three 32-bit floats.
    const inputs = [3]f32{ 2.0, 3.0, 1.0 };

    // Each weight controls how much its matching input contributes.
    // These are hand-picked for learning; a trained model loads its weights.
    const weights = [3]f32{ 0.5, 1.0, 2.0 };
    const bias: f32 = 0.5;

    // A dot product: multiply matching pairs, then add the products.
    var sum: f32 = 0.0;
    for (inputs, weights) |input, weight| {
        const contribution = input * weight;
        std.debug.print("{d:.1} * {d:.1} = {d:.1}\n", .{ input, weight, contribution });
        sum += contribution;
    }

    const score = sum + bias;

    // ReLU is an activation function: keep positive scores, replace negatives
    // with zero. This is a teaching example; our later Llama model uses SiLU.
    const output = @max(@as(f32, 0.0), score);

    std.debug.print("\nWeighted sum: {d:.1}\n", .{sum});
    std.debug.print("Plus bias:   {d:.1}\n", .{score});
    std.debug.print("After ReLU:  {d:.1}\n", .{output});
}
