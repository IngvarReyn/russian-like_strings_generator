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

VOWELS     = [1072, 1077, 1080, 1086, 1091, 1099, 1101, 1102, 1103, 1105]

CONSONANTS = [*1073..1076,1078,1079,*1081..1085,*1087..1090,*1092..1097]


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


def select_letters(arr)
  LETTERS_FREQ.select { |k,v| arr.any?(k) }
end


ONE_LETTER_WORDS_PROBABILITY_ARRAY = provide_distribution(ONE_LETTER_WORDS_FREQ)

VOWELS_PROBABILITY_ARRAY      = provide_distribution(select_letters(VOWELS))

CONSONANTS_PROBABILITY_ARRAY  = provide_distribution(select_letters(CONSONANTS))

######################################


def rl_str_gen          # russin-like strings generator
  words = words_gen(plane_words)
  digital_capitalize(words[0])
  words.map { |a| a << 32 }.flatten[0..-2].push(46).pack("U*")
end


def plane_words
  arr = Array.new(rand(2..15)) { {} }

  arr.each do |el|
    case rand(20)
      when 0
        el[:case] = :acronim
      when 1, 2
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
  #получаем массив с хешами, где описаны свойства будущих слов.
  #согласно этим условиям создаем производный  массив где каждый элемент
  #является массивом с интеджерами, который в будущем станем словом
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
    word = [ONE_LETTER_WORDS_PROBABILITY_ARRAY.sample]
  else
    word = generate_single_syllable_word
  end

  word = add_dash(word) if hash[:dash]

  word
end


def generate_single_syllable_word
  length = rand(20) < 15 ? rand(2..4) : rand(5..6)
  vowel  = VOWELS_PROBABILITY_ARRAY.sample
  word   = Array.new(length)

  case length
  when 2
    word[rand(2)] = vowel
  when 3, 4
    word[rand(1..2)] = vowel
  when 5, 6
    word[-2] = vowel
  end

  word.map! { |el| el ? el : CONSONANTS_PROBABILITY_ARRAY.sample }

  finalize_word(word)
end


def finalize_word(word)
  word = check_same_consonants(word)

  word = manage_y_short(word)

  occasionaly_add_softning_sign(word)
end


def check_same_consonants(arr)
  arr
  
end


def occasionaly_add_softning_sign(arr)
  arr
  
end


def manage_y_short(arr)
  arr
  
end


# insert не подходит если
#слева три согл
#элемент - Ь
#слева и справа два согл
#этот и два след согл
def add_dash(arr)
  return arr if arr.size < 5 or arr.size > 14

  vowel_indexes = []

  arr.each_with_index do |el,i|
    vowel_indexes << i if VOWELS.any?(el)
  end

  dash_zone_borders =
    [
     vowel_indexes[0] == 0 ? 2 : vowel_indexes[0] + 1,
     vowel_indexes[-1] == arr.size-1 ? vowel_indexes[-1] - 1 : vowel_indexes[-1]
    ]

    (dash_zone_borders[0]..dash_zone_borders[-1]).map { |i|
      next if arr[i] == 1100
       }
arr
end


def get_no_insert_range(arr)
  no_insert  = []
  consonants = 0
  
  arr.each_with_index do |el,i|
    VOWELS.any?(el) ? consonants = 0 : consonants += 1
    no_insert << ((i-3)..(i+1)) if consonants == 4
  end
  no_insert  
end


def generate_multi_syllable_word
    generate_single_syllable_word + generate_single_syllable_word
end