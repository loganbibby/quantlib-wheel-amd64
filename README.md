# Generate QuantLib Python wheel

This Docker container generates a Python wheel for [QuantLib](https://www.quantlib.org/).

## Usage

As a quick start, you can run `runme.sh` to handle everything:
 * It builds the Docker container
 * Runs the Docker container to build the Wheel
 * Cleans up after itself like a good lad 

You'll be able to get the wheel it generates in the `drop` directory.

## What it does

The container first downloads QuantLib and QuantLib-SWIG sources based on the version specified using the `QUANTLIB_VERSION` environment variable.

Then both are compiled and installed. *This will take up to four hours.*

The wheel is generated and moved to the drop directory.

You can see the step-by-step in `docker/cmd.sh`.

## Notes

For the build process to complete, your Docker container needs to have access to *at least* 12GB of RAM.
