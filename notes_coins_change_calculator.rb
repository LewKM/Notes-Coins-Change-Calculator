def change_calculator(bill, cash_given)
    if cash_given < bill
        puts "⚠️ Amount paid cannot be less than the amount due"
        return nil
    end

    note_denominations = [1000, 500, 200, 100, 50]
    coin_denominations = [40, 20, 10, 5, 1]
    change = cash_given - bill
    
    remaining_change = change

    note_change_breakdown = []
    coin_change_breakdown = []

    # Notes
    note_denominations.each do |note|
        if remaining_change >= note
            count = remaining_change / note
            remaining_change = remaining_change % note
            note_change_breakdown << [note, count]
        end
    end
    # Coins
    coin_denominations.each do |coin|
        if remaining_change >= coin
            count = remaining_change / coin
            remaining_change = remaining_change % coin
            coin_change_breakdown << [coin, count]
        end
    end
    return [note_change_breakdown, coin_change_breakdown]
end

def print_menu(menu)
    puts  "------------------------------------------------------"
    puts "Code\tItem\t\t\t\tPrice"
    puts "-------------------------------------------------------"
    menu.each_with_index do |(item, price), index|
        spacing = "\t" * (2 - item.length / 4)
        puts "#{index + 1}\t#{item}#{spacing}\t\t\tKshs #{price}"
    end
    puts "-------------------------------------------------------"
end

# Define shopping items and prices
shopping_menu = {
    "Milk" => 50,
    "Bread" => 30,
    "Eggs" => 20,
    "Butter" => 80,
    "Sugar" => 40,
    "Coffee" => 120,
    "Tea Leaves" => 60,
    "Rice" => 100,
    "Flour" => 45,
    "Salt" => 25,
    "Cooking Oil" => 90,
    "Tomatoes" => 15,
    "Potatoes" => 35,
    "Onions" => 30,
    "Bananas" => 10,
    "Apples" => 60
}

sorted_menu = shopping_menu.sort.to_h

# print_menu(sorted_menu)

puts "🎉🎉 Welcome to the Kenyan Shopping Cart and Currency Change Calculator 🎉🎉"
puts ""

# Initialize variables
total = 0
items_selected = []

# Shopping loop
loop do
    print_menu(sorted_menu)
    puts "Select an item by pressing the corresponding number, 'r' to remove an item, or 'q' to calculate total and exit:"
    choice = gets.chomp.downcase

    break if choice == 'q'

    if choice.to_i.between?(1, sorted_menu.length)
        item_index = choice.to_i - 1
        selected_item = sorted_menu.keys[item_index]
        item_price = sorted_menu.values[item_index]

        # Prompt the user for quantity
        puts "Enter the quantity for #{selected_item}:"
        quantity = gets.chomp.to_i
        if quantity < 1
            puts "Invalid quantity. Please enter a positive integer."
            next
        end

        total += item_price * quantity

        # Check if the item already exists in the cart
        existing_item_index = items_selected.index { |item| item[:item] == selected_item }
        if existing_item_index
            # If the item already exists, update its quantity
            items_selected[existing_item_index][:quantity] += quantity
        else
            # If the item doesn't exist, add it to the cart
            items_selected << { item: selected_item, quantity: quantity }
        end

        puts "#{quantity} #{selected_item}(s) added to cart. Current total: Kshs #{total}"
    elsif choice == 'r'
        if items_selected.empty?
            puts "There are no items in the cart to remove."
            next
        end

        # Print the current items in the cart with their indices
        puts "Items in the cart:"
        items_selected.each_with_index do |item, index|
            puts "#{index + 1}. #{item[:item]} (#{item[:quantity]})"
        end

        puts "Enter the number of the item to remove:"
        remove_choice = gets.chomp.to_i

        if remove_choice.between?(1, items_selected.length)
            removed_item = items_selected[remove_choice - 1]

            # Prompt the user for the quantity to deduct
            puts "Enter the quantity to remove for #{removed_item[:item]}:"
            remove_quantity = gets.chomp.to_i

            if remove_quantity < 1 || remove_quantity > removed_item[:quantity]
                puts "Invalid quantity to remove. Please enter a positive integer not exceeding the current quantity."
                next
            end

            # Deduct the specified quantity from the selected item
            removed_item[:quantity] -= remove_quantity
            total -= sorted_menu[removed_item[:item]] * remove_quantity

            puts "#{remove_quantity} #{removed_item[:item]} removed from cart. Current total: Kshs #{total}"
        else
            puts "Invalid choice. Please enter a valid item number to remove."
        end
    else
        puts "Invalid choice. Please select a valid item or press 'q' to calculate total and exit."
    end
end



puts ""
# Print the final items in the cart with their quantities
puts "Items in the cart:"
items_selected.each_with_index do |item, index|
    puts "#{index + 1}. #{item[:item]} (#{item[:quantity]})"
end

puts "Total: Kshs #{total}"


puts ""
# Initialize a hash to store item counts
# Initialize a hash to store item counts
item_counts = {}

# Count the occurrences of each item
items_selected.each do |item|
    item_name = item[:item]  # Extract the item name from the hash
    if item_counts.has_key?(item_name)
        item_counts[item_name] += item[:quantity]
    else
        item_counts[item_name] = item[:quantity]
    end
end

# Sort the items alphabetically
sorted_items = item_counts.keys.sort

# Calculate the total price
total_price = 0

puts "🛒 Items selected:"
puts "--------------------------------------------------------"
puts "Item\t\tQuantity\t\tPrice"
sorted_items.each do |item_name|
    count = item_counts[item_name]
    if shopping_menu[item_name].nil?
        puts "Error: Price not found for #{item_name}. Please check your shopping menu."
        next
    end
    price = shopping_menu[item_name] * count
    total_price += price

    puts "#{item_name}\t\t#{count}\t\t\tKshs #{price}"
end


puts "--------------------------------------------------------"
puts "Total\t\t\t\tKshs #{total_price}"



puts ""
puts "💰 Total BILL: Kshs #{total}"
puts ""

puts "💵 Enter the cash given (Kshs):"
cash_given = gets.chomp.to_i

puts ""

change = change_calculator(total, cash_given)

if change
    note_change, coin_change = change
    puts "💸💸💸 Change Breakdown 💸💸💸"
    puts "💰💰💰 CHANGE DUE: Kshs #{cash_given - total}.00 💰💰💰"
    puts ""
    puts "💵 Notes:"
    note_change.each do |note, count|
        puts " #{count} of Kshs #{note} notes"
    end

    puts "💰 Coins:"
    coin_change.each do |coin, count|
        puts " #{count} of Kshs #{coin} coins"
    end
end
