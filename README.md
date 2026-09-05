# Inference in Zig

A guided learning project: write a small CPU inference engine in Zig, then
serve text generation over HTTP. We use an already-trained model; we do not
train one here.

## Start here

Tested with Zig `0.17.0-dev.1158+1d1193aa7`.

```sh
zig run lessons/01_neuron.zig
```

The first lesson computes one artificial neuron:

```text
inputs × matching weights → add the products → add bias → activation

(2 × 0.5) + (3 × -1) + (1 × 2) = 0
0 + 0.5 = 0.5
ReLU(0.5) = 0.5
```

- **Weight:** a number that scales an input's contribution.
- **Bias:** an additional number added to the weighted sum.
- **Activation:** a function applied to the score. ReLU replaces negative
  values with zero, introducing a nonlinearity.
- **Inference:** computing outputs using fixed model parameters.

Our numbers are hand-picked, so this demonstrates the computation without
claiming to be a trained model. Its output is a number, not a probability or
generated text. A language model combines many numerical operations to score
possible next tokens.

## Your first exercise

Before running the program again:

1. Predict the output if you change the second weight from `-1.0` to `1.0`.
2. Change that number in the file and run it to check your prediction.
3. Restore it, then try a bias of `-0.5`. What does ReLU do now?

In Zig, `const` declares a value that cannot be reassigned, `var` allows
reassignment, and `[3]f32` is an array of three 32-bit floating-point numbers.
The `for` loop walks through the input and weight arrays together.
This lesson uses `std.debug.print`, which writes to stderr.

## Agreed scope and route

We work in small steps: explain the concept, try an exercise, then build on it.
Correctness and understanding come before performance.

1. One neuron — current lesson.
2. Dot products, matrix-vector multiplication, and the model's other operations.
3. Read trained weights and tokenize text.
4. Run the model repeatedly to generate text in the terminal.
5. Add one local HTTP endpoint accepting a prompt and an output limit,
   returning completed text. Handle one generation at a time.

The initial implementation uses CPU and f32. Streaming, GPU acceleration,
public hosting, and training are later work.

## Model target

Target: Karpathy's `stories15M.bin`, a 15-million-parameter model trained on
TinyStories, with an approximately 60 MB checkpoint. The educational
[llama2.c project](https://github.com/karpathy/llama2.c) provides a C reference
implementation and download instructions. We will implement the operations
in Zig and compare numerical results with a fixed reference revision before
claiming correctness. Reference revision and model checksum will be recorded
when we integrate them.

This model is for continuing short stories, not a general chat assistant.
No checkpoint is downloaded yet. The neuron lesson is only the starting
exercise; the inference engine and HTTP server are not implemented yet.
