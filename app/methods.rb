def provide_distribution(hash)
  sample_array = []

  hash.each_key do |k|
    hash[k].times do
      sample_array << k
    end
  end
  sample_array.freeze
  sample_array
end


LETTERS_FREQ = { 1072 => 801,
                 1073 => 159,
                 1074 => 454,
                 1075 => 170,
                 1076 => 298,
                 1077 => 749,
                 1105 => 100,
                 1078 => 94,
                 1079 => 165,
                 1080 => 735,
                 1081 => 121,
                 1082 => 349,
                 1083 => 440,
                 1084 => 321,
                 1085 => 670,
                 1086 => 1097,
                 1087 => 281,
                 1088 => 473,
                 1089 => 547,
                 1090 => 626,
                 1091 => 262,
                 1092 => 26,
                 1093 => 97,
                 1094 => 48,
                 1095 => 144,
                 1096 => 73,
                 1097 => 36,
                 1098 => 4,
                 1099 => 190,
                 1100 => 174,
                 1101 => 32,
                 1102 => 64,
                 1103 => 201
                }.freeze


ONE_LETTER_WORDS_FREQ = { 1080 => 358,
                          1074 => 314,
                          1103 => 127,
                          1089 => 113,
                          1072 => 82,
                          1082 => 54,
                          1091 => 43,
                          1086 => 34
                         }.freeze



ONE_LETTER_WORDS_PROBABILITY_ARRAY = provide_distribution(ONE_LETTER_WORDS_FREQ)


LETTERS_PROBABILITY_ARRAY = provide_distribution(LETTERS_FREQ)




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


def make_common_word(hash)
  if hash[:multi_syllable]
    word = generate_multi_syllable_word
  elsif hash[:one_letter]
    word = ONE_LETTER_WORDS_PROBABILITY_ARRAY.sample
  else
    word = generate_single_syllable_word
  end

  word = add_dash(word) if hash[:dash]

  word
end


def generate_single_syllable_word       # 6 letters max
  length = rand(20) < 15 ? rand(2..4) : rand(5..6)
  vowel  = [1072, 1086, 1091, 1101, 1099, 1080, 1103, 1077, 1105, 1102].sample
  
end