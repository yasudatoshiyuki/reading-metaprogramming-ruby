# 次の仕様を満たすモジュール SimpleMock を作成してください
#
# SimpleMockは、次の2つの方法でモックオブジェクトを作成できます
# 特に、2の方法では、他のオブジェクトにモック機能を付与します
# この時、もとのオブジェクトの能力が失われてはいけません
# また、これの方法で作成したオブジェクトを、以後モック化されたオブジェクトと呼びます
# 1.
# ```
# SimpleMock.new
# ```
#
# 2.
# ```
# obj = SomeClass.new
# SimpleMock.mock(obj)
# ```
#
# モック化したオブジェクトは、expectsメソッドに応答します
# expectsメソッドには2つの引数があり、それぞれ応答を期待するメソッド名と、そのメソッドを呼び出したときの戻り値です
# ```
# obj = SimpleMock.new
# obj.expects(:imitated_method, true)
# obj.imitated_method #=> true
# ```
# モック化したオブジェクトは、expectsの第一引数に渡した名前のメソッド呼び出しに反応するようになります
# そして、第2引数に渡したオブジェクトを返します
#
# モック化したオブジェクトは、watchメソッドとcalled_timesメソッドに応答します
# これらのメソッドは、それぞれ1つの引数を受け取ります
# watchメソッドに渡した名前のメソッドが呼び出されるたび、モック化したオブジェクトは内部でその回数を数えます
# そしてその回数は、called_timesメソッドに同じ名前の引数が渡された時、その時点での回数を参照することができます
# ```
# obj = SimpleMock.new
# obj.expects(:imitated_method, true)
# obj.watch(:imitated_method)
# obj.imitated_method #=> true
# obj.imitated_method #=> true
# obj.called_times(:imitated_method) #=> 2
# ```

module SimpleMock

  def self.new
    obj = Object.new
    obj.class_eval do
      include SimpleMock
    end
    obj.mock
    obj
  end

  def self.mock(obj)
    obj.class_eval do
      include SimpleMock
    end
    obj.mock
  end

  def mock
    @imitated_methods = {}
    @watched_methods = []
    @method_called = {}

    define_singleton_method :add_method_called do |method_name|
      @method_called[method_name] ||= 0
      @method_called[method_name] += 1
    end

    define_singleton_method :method_missing do |method_name, *args, &block|
      if @imitated_methods[method_name]
        add_method_called(method_name)
        @imitated_methods[method_name]
      else
        super
      end
    end

    define_singleton_method :respond_to_missing? do |method_name, *args|
      @imitated_methods[method_name] or super
    end

    define_singleton_method :expects do |method_name, return_value|
      @imitated_methods[method_name] = return_value
    end

    define_singleton_method :watch do |method_name|
      @watched_methods << method_name unless @watched_methods.include? method_name
      unless @imitated_methods[method_name]
        define_singleton_method method_name do |*args|
          add_method_called(method_name)
          super *args if defined?(super)
        end
      end
    end

    define_singleton_method :called_times do |method_name|
      if @watched_methods.include? method_name
        @method_called[method_name]
      end
    end
    self
  end
end
