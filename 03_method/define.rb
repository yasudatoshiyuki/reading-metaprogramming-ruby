# Q1.
# 次の動作をする A1 class を実装する
# - "//" を返す "//"メソッドが存在すること

class A1
  define_method("//") { "//" }
end

# Q2.
# 次の動作をする A2 class を実装する
# - 1. "SmartHR Dev Team"と返すdev_teamメソッドが存在すること
# - 2. initializeに渡した配列に含まれる値に対して、"hoge_" をprefixを付与したメソッドが存在すること
# - 2で定義するメソッドは下記とする
#   - 受け取った引数の回数分、メソッド名を繰り返した文字列を返すこと
#   - 引数がnilの場合は、dev_teamメソッドを呼ぶこと

class A2

  def initialize(method_names=nil)
    method_names.each do |method_name|
      self.class.send(:define_method, "hoge_#{method_name}", Proc.new { |num| (num.nil?) ? self.dev_team : __callee__.to_s * num })
    end
  end

  def dev_team
    "SmartHR Dev Team"
  end
end

# Q3.
# 次の動作をする OriginalAccessor モジュール を実装する
# - OriginalAccessorモジュールはincludeされたときのみ、my_attr_accessorメソッドを定義すること
# - my_attr_accessorはgetter/setterに加えて、boolean値を代入した際のみ真偽値判定を行うaccessorと同名の?メソッドができること

module OriginalAccessor
  def self.included(mod)
    mod.class.define_method(:my_attr_accessor) do |name|
      define_method(name) { instance_variable_get("@#{name}") }
      define_method("#{name}=") do |val|
        instance_variable_set("@#{name}", val)
        if (!!val == val)
          self.define_singleton_method("#{name}?") do
            !!instance_variable_get("@#{name}")
          end
        end
      end
    end
  end
end
