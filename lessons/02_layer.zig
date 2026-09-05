const std = @import("std");

pub fn main() void {
    // A vector: one array of input numbers, shared by all three neurons.
    const inputs = [3]f32{ 2.0, 3.0, 1.0 };

    // A matrix: an array of rows. Each row holds one neuron's weights.
    // [3][3]f32 means three rows, each containing three floats.
    const weights = [3][3]f32{
        .{ 0.5, -1.0, 2.0 },
        .{ 1.0, 1.0, 4.0 },
        .{ -1.0, 0.0, -1.0 },
    };
    const biases = [3]f32{ 0.5, -1.0, 0.5 };
    var outputs: [3]f32 = undefined;

    // 0.. supplies an index alongside each row and bias.
    for (weights, biases, 0..) |row, bias, neuron_index| {
        // This inner loop is the dot product from lesson 1.
        // Doing it for every row computes the matrix-vector product.
        var sum: f32 = 0.0;
        for (row, inputs) |weight, input| {
            sum += weight * input;
        }

        // Adding biases and applying ReLU happen AFTER the weighted sums.
        // ReLU is for this teaching layer; the later Llama model uses SiLU.
        const score = sum + bias;
        outputs[neuron_index] = @max(@as(f32, 0.0), score);

        std.debug.print("Neuron {d}: sum {d:.1}, bias {d:.1}, score {d:.1}, output {d:.1}\n", .{
            neuron_index + 1, sum, bias, score, outputs[neuron_index],
        });
    }

    // Every element has been assigned by the loop before we read this array.
    std.debug.print("\nLayer output: [{d:.1}, {d:.1}, {d:.1}]\n", .{
        outputs[0], outputs[1], outputs[2],
    });
}
