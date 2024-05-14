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
    puts  "-----------------------"
    puts "Code\tItem\t\t\t\tPrice"
    menu.each_with_index do |(item, price), index|
        puts "#{index + 1}\t#{item}\t\t\t\tKshs #{price}"
    end
    puts "-----------------------"
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
    puts "Select an item by pressing the corresponding number, or press 'q' to calculate total and exit:"
    choice = gets.chomp.downcase

    break if choice == 'q'

    if choice.to_i.between?(1, sorted_menu.length)
        item_index = choice.to_i - 1
        selected_item = sorted_menu.keys[item_index]
        item_price = sorted_menu.values[item_index]

        total += item_price
        items_selected << selected_item

        puts "#{selected_item} added to cart. Current total: Kshs #{total}"
    else
        puts "Invalid choice. Please select a valid item or press 'q' to calculate total and exit."
    end
end

puts ""
# Initialize a hash to store item counts
item_counts = {}

# Count the occurrences of each item
items_selected.each do |item|
    if item_counts.has_key?(item)
        item_counts[item] += 1
    else
        item_counts[item] = 1
    end
end

# Sort the items alphabetically
sorted_items = item_counts.keys.sort

# Calculate the total price
total_price = 0

puts "🛒 Items selected:"
puts "--------------------------------------------------------"
puts "Item\t\tQuantity\t\tPrice"
sorted_items.each do |item|
    count = item_counts[item]
    price = shopping_menu[item] * count
    total_price += price

    puts "#{item}\t\t#{count}\t\t\tKshs #{price}"
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
