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

## Lesson 2: a layer of neurons

```sh
zig run lessons/02_layer.zig
```

All three neurons receive the same input vector `[2, 3, 1]`. Each row in the
weight matrix belongs to one neuron:

```text
Weights                 Inputs      Weighted sums
[ 0.5  -1   2 ]         [ 2 ]        [  0 ]
[ 1     1   0 ]    ×    [ 3 ]   =    [  5 ]
[-1     0  -1 ]         [ 1 ]        [ -3 ]

Add biases:  [0, 5, -3] + [0.5, -1, 0.5] = [0.5, 4, -2.5]
Apply ReLU:  [0.5, 4, 0]
```

Matrix-vector multiplication computes only the weighted sums. Bias addition
and activation are separate steps. A layer can have a different number of
neurons than inputs: two neurons receiving three inputs need two rows of
three weights and produce two outputs.

Zig's `[3][3]f32` is an array of three arrays. The outer loop visits neurons;
the inner loop visits one neuron's weights and the shared inputs. `0..`
provides the zero-based index used to store each output. `undefined` leaves
the output array uninitialized: every element must be written before it is
read, as this loop does.

Exercise: change only the second neuron's last weight from `0.0` to `2.0`.
Predict the complete output vector, then run the program to check it.

## Agreed scope and route

We work in small steps: explain the concept, try an exercise, then build on it.
Correctness and understanding come before performance.

1. One neuron — lesson 1.
2. Matrix-vector multiplication — lesson 2; other model operations follow.
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
No checkpoint is downloaded yet. The lessons are starting exercises;
the inference engine and HTTP server are not implemented yet.
