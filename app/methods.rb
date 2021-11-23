def rl_str_gen          # russin-like strings generator

end


def base_string
  x   = [*1040..1103, 1105, 1025]
  arr = Array.new(rand(3..250)) { x.sample }
  i   = rand(1..15)

  while i < arr.size
  arr[i] = 32
  i += rand(2..16)
  end

  arr.pack("U*")
end


def plane_words
  arr = Array.new(rand(2..15)) { {} }

  arr.each do |el|
    case rand(10)
      when 0
        el[:case] = :acronim
      when 1
        el[:case] = :capital
      else
        el[:case] = :downcase
    end

    if el[:case] != :acronim
      el[:multi_syllable] = rand(5) == 0 ? false : true
      
    end

    if el[:multi_syllable] == true
      el[:dash] = rand(20) == 0 ? true : false
    elsif el[:multi_syllable] == false
      if rand(2) == 0
         el[:one_letter] = true
         el[:case]       = :downcase
      else
         el[:one_letter] = false
      end
    end
  end
  
end


def words_gen(arr)
  arr.map do |el|
    case el[:case]
      when :acronim
        make_acronim
      when :downcase
        make_common_word(el)
      when :capital
        digital_capitalize(make_common_word(el))
    end
  end

end


def make_acronim
  letters = [*1040..1048, *1050..1065, *1069..1071, 1025]
  Array.new(rand(2..5)) { letters.sample }
end


def digital_capitalize(arr)
  if arr[0] == 1105
    arr[0] = 1025
  elsif arr[0] > 1071
    arr[0] -= 32
  end

  arr
end


def common_word(hash)
  if hash[:multi_syllable]
    word = generate_multi_syllable_word
  elsif hash[:one_letter]
    word = [1072, 1103, 1074, 1086, 1091, 1080, 1082, 1089]
    word.sample
  else
    word = generate_single_syllable_word
  end

  word = add_dash(word) if hash[:dash]

  word
end