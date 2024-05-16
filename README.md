# Notes-Coins-Change-Calculator
## Shopping Cart and Currency Change Calculator

This Ruby script serves as a simple shopping cart and currency change calculator for a Kenyan market. It allows users to select items, specify quantities, remove items, calculate the total bill, and determine the change to be given back based on the cash provided.

### Features

1. **Item Selection**: Users can browse through a list of available items with corresponding codes and prices. They can select items by entering the corresponding code.

2. **Quantity Adjustment**: Users can specify the quantity of each selected item.

3. **Item Removal**: Users can remove items from the cart if they change their mind or make a mistake.

4. **Total Calculation**: The script calculates the total bill based on the selected items and quantities.

5. **Change Calculation**: Users can enter the amount of cash provided, and the script calculates the change to be given back.

### Usage

1. **Selecting Items**: Run the script and follow the prompts to select items by entering their corresponding codes.

2. **Adjusting Quantities**: After selecting an item, enter the desired quantity when prompted.

3. **Removing Items**: To remove an item, enter 'r' when prompted for a choice, then select the item to remove and specify the quantity to deduct.

4. **Calculating Total**: Enter 'q' to calculate the total bill and exit the shopping loop.

5. **Providing Cash**: After calculating the total bill, enter the amount of cash provided when prompted.

6. **Viewing Change Breakdown**: If change is due, the script displays a breakdown of the change, including notes and coins.

### Error Handling

The script includes error handling for various scenarios, such as invalid inputs, insufficient cash provided, and items with missing prices in the shopping menu.

### Note

Ensure that the shopping menu (`shopping_menu` hash) is correctly configured with item names as keys and corresponding prices as values.

### Sample Run

```ruby
# Sample run code
# ruby notes_coins_change_calculator.rb
```

### Requirements

- Ruby interpreter installed (version 2.0 or higher)

### Credits

This script was developed by Lewis Mwendwa Kathembe and is provided under the [MIT License](https://opensource.org/licenses/MIT).

### Feedback

If you have any feedback, suggestions, or bug reports, please feel free to [open an issue](https://github.com/your-repo/issues). Your contributions are welcome!

Enjoy shopping with the Kenyan Shopping Cart and Currency Change Calculator!


Currency Options: Not implemented in the provided code. This could be added as a configuration option at the beginning of the program to allow users to select their preferred currency for displaying prices.