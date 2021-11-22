require "rspec"
require_relative "../app/methods"

describe "method rl_str_gen" do

  it "should return a string" do
    1000.times do
      expect(rl_str_gen).to be_an_instance_of(String)
    end
  end


  it "should contain only valid symbols" do
    1000.times do
      expect(rl_str_gen.match /[^а-яё \-,\.:!\?\";]/i).to be_nil
    end
  end


  it "should not be over 300 symbols" do
    100000.times do
      expect(rl_str_gen.size).to be <= 300
    end
  end


  it "should contain from 2 to 15 words" do
    1000.times do
      str = rl_str_gen
      expect(str.size).to be <= 300
      expect(str.gsub("- ", "").match?(/\A *(?:[^ ]+ +){1,14}[^ ]+ *\z/)).to be true
    end
  end


  it "should not contain words over 15 letters" do
    1000.times do
      words = rl_str_gen.scan(/[а-яё]+(?:-[а-яё]+)?/i)
      expect(words.count { |el| el.size > 15 }).to eq(0)
    end
  end


  it "should allow only particular signs after words within sentence" do
    1000.times do
      within = rl_str_gen.split.reject { |el| el == "-" }[0..-2]
      expect(within.reject { |el| el.match? /[а-яё]\"?[,:;]?\z/i }
                   .size)
                   .to eq(0)
    end
  end


  it "should allow only particular signs in the end of the sentence" do
    1000.times do
      expect(rl_str_gen.match? /.*[а-яё]+\"?(\.|!|\?|!?|\.\.\.)\z/)
                              .to be true
    end
  end


  it "should not allow unwanted symbols inside words" do
    1000.times do
      expect(rl_str_gen.match /[а-яё-][^а-яё -]+[а-яё-]/i).to be_nil
    end
  end


  it "should not allow multiple punctuation marks" do
    1000.times do
      expect(rl_str_gen.match(/([^а-яё\.]) *\1/i)).to be_nil
    end
  end


  it "should exclude unwanted symbols before words" do
    1000.times do
    expect(rl_str_gen.match /(?<![а-яё])[^ \"а-яё]+\b[а-яё]/i).to be_nil
    end
  end


  it "should correctly use quotation marks" do
    1000.times do
      str = rl_str_gen
      expect(str.scan(/\"/).size.even?).to be true
      expect(str.scan(/\".+?\"/)
                .reject { |el| el.match? /\"[а-яё].+[а-яё]\"/i }
                .size)
                .to eq(0)
    end
  end


  it "should not allow words starting with ь,ъ,ы" do
    1000.times do
      expect(rl_str_gen.match /\b[ьъы]/i).to be_nil
    end
  end


  it "should not contain capital letters inside words if not an acronim" do
    1000.times do
      rl_str_gen.gsub(/[^а-яё ]/i, "").split.each do |el|
        unless el.match? /\A[А-ЯЁ]{2,}\z/
          expect(el.match /\A.+[А-ЯЁ]/).to be_nil
        end
      end
    end
  end


  it "should allow acronims only to 5 letters long" do
    1000.times do
      acr = rl_str_gen.gsub(/[^а-яё ]/i, "").scan(/[А-ЯЁ]{2,}/)
      expect(acr.count { |a| a.size > 5 }).to eq(0)
    end
  end


  it "should not allow one-letter words with a capital letter" do
    1000.times do
      expect(rl_str_gen.match(/ \"?[А-ЯЁ]\b/)).to be_nil
    end
  end


  it "should always have vowel after й at the beginning of the word" do
    1000.times do
      expect(rl_str_gen.match /\bй[^ео]/i).to be_nil
    end
  end


  it "should allow only particular letters after й inside words" do
    1000.times do
      expect(rl_str_gen.match /\Bй[ьъыёуиаэюяжй]/i).to be_nil
    end
  end


  it "should always be vowel in 2- and 3- letter words" do
    1000.times do
      rl_str_gen.gsub(/[^а-яё ]/i, "")
                .split
                .select { |el| el.size == 2 or el.size == 3}
                .reject { |el| el.match?(/\A[А-ЯЁ]+\z/)}
      .each do |w|
        expect(w).to match(/[аоуэыияеёю]/i)
      end
    end
  end


  it "should allow only particular one-letter words" do
    1000.times do
      rl_str_gen.scan(/\b[а-яё]\b/i).each do |word|
        expect(word).to match(/[явуоиксжб]/i)
      end
    end
  end


  it "should not allow more than 4 consonant letters in a row" do
    1000.times do
      rl_str_gen.gsub(/[^а-яё ]/i, "").split.each do |el|
        unless el.match? /\A[А-ЯЁ]{2,}\z/
          expect(el.match /[^аоуэыияеёю ]{5,}/i).to be_nil
        end
      end
    end
  end


  it "should not allow more than 2 vowel letters in a row" do
    1000.times do
      rl_str_gen.gsub(/[^а-яё ]/i, "").split.each do |el|
        unless el.match? /\A[А-ЯЁ]{2,}\z/
          expect(el.match /[аоуэыияеёю]{3,}/i).to be_nil
        end
      end
    end
  end


  it "should not allow more than 2 same consonant letters in a row" do
    1000.times do
      rl_str_gen.gsub(/[^а-яё ]/i, "").split.each do |el|
        unless el.match? /\A[А-ЯЁ]{2,}\z/
          expect(el.match /([^аоуэыияеёю])\1\1/i).to be_nil
        end
      end
    end
  end


  it "should start with a capital letter" do
    1000.times do
      expect(rl_str_gen).to match(/\A\"?[А-ЯЁ]/)
    end
  end


  it "should contain at least 40% vowels in multi-syllable word" do
    1000.times do
      rl_str_gen.gsub(/[^а-яё ]/i, " ")
                .split
                .select { |w| w.match? /[аоуэыияеёю].*[аоуэыияеёю]/i }
      .each do |el|
        unless el.match? /\A[А-ЯЁ]{2,}\z/
          found = (el.scan(/[аоуэыияеёю]/i).size)
          calc  = ((el.size - el.scan(/[ъь]/i).size) * 0.4).to_i
          res   = found >= calc ? ">= #{calc} vowels" : "#{found} vowels"
          expect([res, el]).to eq([">= #{calc} vowels", el])
        end
      end
    end
  end


  it "should contain 5 or less consonants in single-syllable words" do
    1000.times do
      rl_str_gen.gsub(/[^а-яё -]/i, "")
                .split
                .reject { |w| w.match?(/-|([аоуэыияеёю].*[аоуэыияеёю])/i) ||
                              w.match?(/\A[А-ЯЁ]{2,}\z/) }
      .each do |w|
        expect(w.size).to be <= 6
      end
    end
  end


  it "should allow only яеёю after ъ" do
    1000.times do
      expect(rl_str_gen.gsub(/\b[А-ЯЁ]{2,}\b/, "").match /ъ[^яеёю]/i).to be_nil
    end
  end


  it "sould not allow a vowel at the begining of the word"\
   "in single-syllable words if they have 3 or more letters" do
    1000.times do
    rl_str_gen.gsub(/[^а-яё -]/i, "")
                .split
                .reject { |w| w.match?(/-|([аоуэыияеёю].*[аоуэыияеёю])/i) ||
                              w.match?(/\A[А-ЯЁ]{2,}\z/) || w.size < 3 }
      .each do |w|
        expect(w).to match(/\A[^аоуэыияеёю]/i)
      end
    end
   end


  it "should forbid Ь and Ъ in acronims" do
    1000.times do
      expect(rl_str_gen.match(/(?=\b[А-ЯЁ]{2,}\b)\b[А-ЯЁ]*[ЪЬ][А-ЯЁ]*\b/)).to be_nil
    end
  end

end