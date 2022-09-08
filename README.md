# Simple Warehouse
This is a simple command-line warehouse management tool. The user can record the storage and removal of crates of variable sizes on a grid of dynamic 'shelves'.

It accepts the following 7 commands:

| Command | Description |
| --- | --- |
| `help` | Shows the help message. |
| `init W H` | (Re)Initialises the application as an empty W x H warehouse. |
| `store X Y W H P` | Stores a crate of product code P and of size W x H at position (X,Y).<br>The crate will occupy W x H locations on the grid.|
| `locate P` | Show a list of all locations occupied by product code P. |
| `remove X Y` | Remove the entire crate occupying the location (X,Y). |
| `view` | Output a visual representation of the current state of the grid.<br>Position (1,1) should be at the bottom left position on the grid and (1, H) should be the top left. |
| `exit` | Exits the application. |

- Arguments W, H, X and Y will always be integers, and P will always be a single character.
- You should not worry about validating the format of the input.
- A crate of dimensions 2 x 3 will occupy 6 locations in the grid.

The user should be shown a graceful error message when:
- Trying to store a crate at a position which doesn't exist.
- Trying to store a crate which doesn't fit.
- Trying to remove a crate which doesn't exist.

![](./example.svg)

## Task
Adapt the provided skeleton application with the functionality described above.  Feel free to improve the existing code as you see fit.

We recommend writing unit tests for your code in either RSpec or Minitest to ensure the correct functionality is
achieved.  However, to save time, we suggest you do not write full integration tests that simulate `stdin` and capture `stdout`.


Overwrite this `README`, outlining the reasoning behind your design decisions and any ways in which you think your code could be improved.  If you need to refer back to these instructions, [they are duplicated here](./INSTRUCTIONS.md).

Please return an archive (`.zip` or `tar.gz`) of your local repository.

### Alternatives to Ruby
If you feel your skills are better demonstrated in a different language, please feel free to submit your solution in the language of your choice.  Be sure to include full instructions on how to build and run your code.

## Documentation
`simple_warehouse` is a CLI application to create a warehouse and crates.

Main flow of application lies in [`Command`](./app/command.rb) class. To classify user input,
it uses [`Regex`](./app/regex.rb) module where input is matched against pre-defined list of regex patterns.

A list of expected errors is defined in [`Errors`](./app/errors.rb) module. The list of errors are used for raising relevant Exceptions and rescuing them with user-friendly message.

[`Warehouse`](./app/models/warehouse.rb) and [`Crate`](./app/models/crate.rb) classes are used for creating relevant objects, modifying and operating basic calculations on them.

### Example commands:
`init W H`

Initializes a `W x H` matrix and fills it with zeros.
X and Y should be positive integers, otherwise, an exception
will be raised (user will be notified without exiting application)

```console
> init 10 10
```

`view`

Prints current state of matrix. The view is distorted if matrix
height and width is higher than 10.

```console
> view
10 0 0 0 0 0 0 0 0 0 0
9 0 0 0 0 0 0 0 0 0 0
8 0 0 0 0 0 0 0 0 0 0
7 0 0 0 0 0 0 0 0 0 0
6 0 0 0 0 0 0 0 0 0 0
5 0 0 0 0 0 0 0 0 0 0
4 0 0 0 0 0 0 0 0 0 0
3 0 0 0 0 0 0 0 0 0 0
2 0 0 0 0 0 0 0 0 0 0
1 0 0 0 0 0 0 0 0 0 0
0 1 2 3 4 5 6 7 8 9 10
```

`store X Y w h product_code`

Stores a crate with given attributes. User will be notified if:
- store command is executed without initializing warehouse
- crate parameters are out of boundaries of warehouse
- a crate already exist in given location
- a crate with given product code already exists

```console
> store 1 1 3 4 a
```

To see the current state and new crate, user can type `view`
```console
> view
10 0 0 0 0 0 0 0 0 0 0
9 0 0 0 0 0 0 0 0 0 0
8 0 0 0 0 0 0 0 0 0 0
7 0 0 0 0 0 0 0 0 0 0
6 0 0 0 0 0 0 0 0 0 0
5 0 0 0 0 0 0 0 0 0 0
4 a a a 0 0 0 0 0 0 0
3 a a a 0 0 0 0 0 0 0
2 a a a 0 0 0 0 0 0 0
1 a a a 0 0 0 0 0 0 0
0 1 2 3 4 5 6 7 8 9 10
```

`locate product_code`

Retrives all location points where product with name `product_code` exists

```console
> locate a
"List of locations occupied by Product: a"
[[1, 1], [1, 2], [1, 3], [1, 4], [2, 1], [2, 2], [2, 3], [2, 4], [3, 1], [3, 2], [3, 3], [3, 4]]
```

`remove X Y`

Removes entire crate located in `[x: 1, y: 1]`

```console
> remove 1 1
```

`help`

Prints help message

`exit`

Exits the application
