# Examples

The `ballerinax/hubspot.crm.engagement.notes` connector provides practical examples illustrating usage in various scenarios.

1. [Managing a single note](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagement.notes/tree/main/examples/manage_notes) - Operations on a single note such as creating, updating and deleting, as well as getting a list of available notes and searching for a note by its content.

2. [Working with a batch of notes](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagement.notes/tree/main/examples/manage_notes_batch) - Operations on a batch of notes such as creating, updating and deleting, as well as getting notes by their ID.

## Prerequisites

1. Generate hubspot credentials to authenticate the connector as described in the [setup guide](../README.md).

2. For each example, create a `Config.toml` file with the relevant configuration. Here's an example of how your `Config.toml` file should look:
    ```toml
    clientId = "<Client ID>"
    clientSecret = "<Client Secret>"
    refreshToken = "<Access Token>"
    ```
    
## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
