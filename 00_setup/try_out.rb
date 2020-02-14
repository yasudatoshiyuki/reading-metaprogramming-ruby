class TryOut

  attr_accessor :first_name
  def initialize(first_name, middle_name, last_name=nil)
    @first_name = first_name
    @middle_name = middle_name
    @last_name = last_name
  end

  def full_name
    name = if @last_name
      "#{@first_name} #{@middle_name} #{@last_name}"
    else
      "#{@first_name} #{@middle_name}"
    end
    if @upcase
      name.upcase
    else
      name
    end
  end

  def upcase_full_name
    full_name.upcase
  end

  def upcase_full_name!
    @upcase = true
    full_name
  end
  # このクラスの仕様
  # コンストラクタは、2つまたは3つの引数を受け付ける。引数はそれぞれ、ファーストネーム、ミドルネーム、ラストネームの順で、ミドルネームは省略が可能。
  # full_nameメソッドを持つ。これは、ファーストネーム、ミドルネーム、ラストネームを半角スペース1つで結合した文字列を返す。ただし、ミドルネームが省略されている場合に、ファーストネームとラストネームの間には1つのスペースしか置かない
  # first_name=メソッドを持つ。これは、引数の内容でファーストネームを書き換える。
  # upcase_full_nameメソッドを持つ。これは、full_nameメソッドの結果をすべて大文字で返す。このメソッドは副作用を持たない。
  # upcase_full_name! メソッドを持つ。これは、upcase_full_nameの副作用を持つバージョンで、ファーストネーム、ミドルネーム、ラストネームをすべて大文字に変え、オブジェクトはその状態を記憶する
end
