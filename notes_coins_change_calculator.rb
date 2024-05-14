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

puts "🎉🎉 Welcome to the Kenyan Currency Change Calculator 🎉🎉"

puts "💵 Enter the BILL (Kshs):"
bill = gets.chomp.to_i

puts "💰 Enter the CASH GIVEN (Kshs):"
cash_given = gets.chomp.to_i
puts ""

change = change_calculator(bill, cash_given)

if change
    note_change, coin_change = change
    puts "💸💸💸 Change Breakdown 💸💸💸"
    puts "💰💰💰 CHANGE DUE: Kshs #{cash_given - bill}.00 💰💰💰"
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
