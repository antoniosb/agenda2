module ServicesHelper

def number_to_currency_br(number)
  if number
    number_to_currency(number, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
end
  
end
