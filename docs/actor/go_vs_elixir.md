# Golang 和 Elixir 比较

<https://www.jianshu.com/p/b59677547b26>

本文章翻译自 [https://blog.codeship.com/comparing-elixir-go](https://link.jianshu.com?t=https%3A%2F%2Fblog.codeship.com%2Fcomparing-elixir-go)

## 译者：关于这篇译文

> 编程语言的争论是程序员的“圣战”之一。另外几个是：Tab vs. 空格, Vim vs. Emacs

Golang (以下称作"Go") 和 Elixir 是两种在很多方面有竞争关系的语言，应用场景类似，并且都比较年轻[[1\]](#fn1)，所以比较这两者，还是有意义的。

我使用 Go 和 Elixir 都有一段时间了，有用他们来做过一些基础的网络应用程序[[2\]](#fn2)。我在学习、使用两者的过程中，也一直在思考、探索两者之间的区别，所以翻译相关的文章的时候，应该不至于产生大的理解偏差。

Go 是中国区程序员的新宠，大概 2015年底[[3\]](#fn3)，突然在中国获得了广大程序员和(创业)老板的青睐，我当时刚好有每天刷招聘网站的习惯，所以对Go在中国的一夜爆发印象很深。而 Elixir 是个相对小众的语言，底层基于Erlang/OTP, 从Ruby社区吸取了很多优点设计成的一个现代编程语言，虽然听上去只是某一小撮儿程序员的玩具，但实际上却已经非常成熟，完全可以用于生产环境。

现实世界里到处都是权衡取舍，权衡自然要比较。但比较计算机技术耗时费力：要比较他们，就必须对两者都有一定的了解。我们需要一些时间来研究书籍和文档，多数还要实地演练一下，才能对某种技术有一个比较全面的了解。最后才能深刻理解其长处、短处、适应场景等。这是个过程，要求程序员有钻研的耐心，也要求老板开明，给我们时间和自由去学习、尝试各种新技术。

而比较编程语言更复杂一些。一是从初学习一个编程语言，到顺利上手，再到对其拥有自己的看法需要更多的时间；二是编程语言容易形成心理壁垒，一旦掌握了某种编程语言，很多程序员倾向于用它来解决任何问题[[4\]](#fn4)，甚至激烈的捍卫所谓的“世界上最好的语言”[[5\]](#fn5)， 这影响了我们的理性判断。我自认在翻译此文章的时候，也无法做到完全隐藏个人偏好倾向，但尽量保持中立，少做诱导性陈述。

编程语言在程序员找工作的过程中，也发挥着特殊的作用。“编程语言不重要” 之类的话没有实际意义，因为目前的企业招聘，往往是基于编程语言来寻找候选人的，比如，企业会指定招聘 C/C++ 程序员，或 Python 程序员。企业有自己实际情况的考虑，不同编程语言的应用场景不一，e.g. 招聘 OC / Swift 语言程序员其实就是招聘iOS平台开发。企业里前端、后端、移动端各团队的细致分工，让多数前端很少碰后端的知识，后端的也很少接触前端的内容，这种分化日趋严重。但事情本不该如此，程序员本就是独立工作者，与写作，音乐创作类似，程序员的世界里个人的影响要大于群体，所谓的群策群力、团队精神是一种误导，看看 github 上的项目，多数贡献都来自一两个核心开发者，其他零星的 bug 修复虽然数量众多却不能影响项目的发展。未来，程序员建立个人影响力可能会越来越重要。上班族会逐渐变为自由职业者，为公司工作逐渐过渡到为自己工作，那时候对各种技术都有广泛涉猎的程序员，将更有竞争力，而目前企业对程序员技术栈的细致分工，显然是对其个人能力的妨碍。

要特别声明的是, 仅通过比较两种编程语言的热度，不能说明某种编程语言更“好”、更值得学习、更有前景。一种语言“流行”的原因很复杂，但跟语言设计是否精良应该没有太大关系。使用某种语言的程序员的平均薪资水平，与其热度也不吻合，市场价格取决于供需，跟语言没有太大关系。抱着阐述语言“前景”的目的写文章也没有意义，因为不论最后结论怎样，都无法改变读者现有的爱好倾向，只能将其加深：文章见解与你的相符则赞之并深以为然，相违则嗤之以鼻。其实最有用的建议是两种都学。掌握多种编程语言已经成为迈向优秀程序员必须的一步。每个编程语言的背后是一个大的社区生态环境，掌握了语言本身，才能了解这个生态环境中的技术。

文章原文及本译文从来没有打算说服你学习某种编程语言，排斥另外一种。

比较的意义在于，一者了解文章中提到的未听说过的技术概念，扩展视野；二来通过这种比较，我们能够了解每种语言在设计上所作出的权衡取舍。编程语言作为一个设计给其他程序员使用的产品，向前兼容是强制性的：一旦第一版发布，其中的设计错误有可能再也没有机会修改。而正是这些设计决策，决定了某种语言更适合解决什么问题，了解这些，帮助我们在面对特定问题的时候，做编程语言层面的抉择。

之前一直想写类似的文章，迟迟未能动笔。前几天偶然搜到这一篇文章，感觉作者的理解很到位，覆盖很全面，比我自己写肯定好多了，所以决定直接翻译过来给大家分享。搬运过来，再加上自己对某些概念的注解，就是一篇很好的技术文章了。所以读的时候，千万不要漏掉了注解的内容。

> 又要睡觉了， 还是一个字都没翻译！前面好像已经坑了四个人，对不住只能再坑一下已经读到这里的朋友。。
> 2018年02月03日19:29:34 开工, again

## 搬运正文

在过去的几年里, Elixir 和 Go 语言的热度都有显著的增长, 并且都经常被正在寻找高并发解决方案的开发人员所尝试. 这两种编程语言遵循着相似的原则, 但都做出了一些核心的, 影响了他们可能的应用场景的权衡取舍.

让我们通过了解他们的背景, 编程风格, 以及怎样处理并发等方面, 比较这两者.

```
太懒了，2018年02月08日13:28:57 开工, again again
```

### 背景

[Go 语言](https://link.jianshu.com?t=https%3A%2F%2Fgolang.org) 是 [2009](https://link.jianshu.com?t=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FGo_(programming_language)%23History) 年由Google开发的，编译后是平台相关的本地可执行文件[[6\]](#fn6). 开始的时候，它是作为一个实验性的项目，目的是针对其他编程语言[[7\]](#fn7) 的主要槽点，并保留他们的强项，开发出一个新的编程语言。

Go 的目标设定是，平衡开发速度，并发，性能，稳定，可移植性 和 可维护性，而它也完美的达成了这一目标。所以呢，Docker 和 InfluxDB 就是用 Go 开发的，并且 [很多主流公司](https://link.jianshu.com?t=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FGo_(programming_language)%23Projects_using_Go) (包括 Google, Netflix, Uber, Dropbox, SendGrid 和 SoundCloud) 也在使用 Go 开发各式各样的工具。

[Elixir 语言](https://link.jianshu.com?t=https%3A%2F%2Felixir-lang.org) 是 [2011](https://link.jianshu.com?t=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FElixir_(programming_language)%23History) 年由来自 Plataformatec 的 [Jose Valim](https://link.jianshu.com?t=https%3A%2F%2Ftwitter.com%2Fjosevalim) 开发的。它运行在 Erlang BEAM 虚拟机之上。
 Erlang 最早是 [1986](https://link.jianshu.com?t=https%3A%2F%2Fwww.ericsson.com%2Fnews%2F141204-inside-erlang-creator-joe-armstrong-tells-his-story_244099435_c) 年，由爱立信公司为高可用，分布式的电话系统开发的。此后 Erlang 被拓展到了许多其他领域，比如 web server, 并达到过 [9 个 9 的可用性](https://link.jianshu.com?t=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FHigh_availability%23Percentage_calculation) (31 毫秒/年 的宕机时间).

Elixir 的设计目标是，让 Erlang VM 有更高的可扩展性，更高的生产力，同时保持跟 Erlang 生态圈的兼容性。为完成这一目标，它允许在 Elixir 代码中使用 Erlang 库，反之亦然 (Shawn: Erlang 代码中也可以使用 Elixir 库)。

> 为避免重复, 在本文中，我们把 "Elixir/Erlang/BEAM" 都统称为 "Elixir"

[许多公司](https://link.jianshu.com?t=https%3A%2F%2Fgithub.com%2Fdoomspork%2Felixir-companies) 在生产环境中使用 Elixir。包括 Discord, Bleacher Report, Teachers Pay Teachers, Puppet Labs, Seneca Systems, 和 FarmBot。很多其他的项目是用 Erlang 构建的，包括 WhatsApp, Facebook 的聊天服务, 亚马逊的 CloudFront CDN, Incapsula, Heroku’s 路由和日志层, CouchDB, Riak, RabbitMQ, 还有**占世界将近一半的电话系统**。

### 编程风格

要对 Elixir 和 Go 作出一个可靠的比较，就要理解他们各自的 run-time [[8\]](#fn8) 的核心原则。因为这些基础构件是其他一切的来源。

对于有传统的 C 风格编程背景的人来说，Go 的风格看起来会更熟悉一点，即使这个语言做了一些更偏爱函数式编程风格的决定。你将看到你感觉很熟悉的 静态类型，指针，还有结构体。

函数可以从结构体创建，也可以附着于结构体上，但以一种更加可组合的方式。函数可以在任何地方创建，并附着到类型上，而不是把函数嵌入到对象里，然后再从那个对象扩展(继承).

如果需要使用多个结构体类型调用一个方法，可以定义个接口，来提供更好的灵活性。跟通常的面向对象的语言里的接口不大一样，那些语言里，必须在一开始定义某个对象实现了某个接口。在 Go 语言里，接口可以自动的应用在一切匹配得上的类型上面。这里有一个 [Go 接口的好例子](https://link.jianshu.com?t=https%3A%2F%2Fgobyexample.com%2Finterfaces)。

Elixir 更偏爱函数式风格，但掺杂了一些来自面向对象编程的原则，让它看起来没那么另类，让来自面向对象领域的程序员转到函数式风格时更容易些。

Elixir 里变量是不可变的，并且使用消息传递(来共享数据)，所以不会把指针传来传去。这意味着函数操作在函数式编程里面更加“字面化”：传进一些参数去，然后返回一个没有副作用的结果。这简化了开发中的很多方面，包括测试 和 代码可读性。

由于数据不可变，所以像 for 循环之类的常见的操作，在 Elixir 里面没法用，因为你没法儿递增一个计数器(counter)[[9\]](#fn9)。这种的操作要用递归实现，尽管 `Enum` 库以一种很方便的形式，提供了一些常见的循环模板。

因为递归的使用是如此频繁，Elixir 也使用 [尾递归](https://link.jianshu.com?t=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F310974%2Fwhat-is-tail-call-optimization%23310980): 如果函数的最后一个调用是调用它本身的话，调用栈不会增长，避免了栈溢出的错误[[10\]](#fn10)。

Elixir 到处都在使用模式匹配，有点像 Go 使用 接口 的那种方法。在 Elixir 里，一个函数可以这样定义：

```elixir
def example_pattern(%{ "data" => %{ "nifty" => "bob", "other_thing" => other}}) do
  IO.puts(other)
end
```

通过使用 map 模板作为参数，仅仅当传进来的参数满足以下条件时，这个函数才会被调用：参数是一个 map 类型，并且有个 `"data"` 字段，`"data"` 字段的值又是一个嵌套的 map 类型，它里面包含了一个值为 `"bob"` 的 `"nifty"` 字段，以及一个 `"other_thing"` 字段。

匹配成功的话，参数的 `"other_thing"` 字段的值会被赋值给 `other` 变量，在函数体内就可以访问`other` 变量了。

模式匹配被用在各种地方，从函数参数到变量赋值，特别是递归。这里有[几个例子](https://link.jianshu.com?t=https%3A%2F%2Fquickleft.com%2Fblog%2Fpattern-matching-elixir%2F)来帮助理解模式匹配。结构体可以被定义为类型，然后一样被用在模式匹配里。

这些方式(Go 的 Interface 和 Elixir 的模式匹配)在原则上很相似，都将数据结构和数据操作分离开来，都用匹配的方式来定义函数调用，Go 是通过接口，而 Elixir 通过模式匹配。[[11\]](#fn11)

虽然 Go 允许通过特定的类型来调用一个函数，比方说 `g.area()`, 但跟 `area(g)` 基本是一回事儿。这方面，两种语言唯一的区别是，在 Elixir 里，`area()` 必须返回一个结果，但 Go 里 `area()` 可能潜在的操作了一个内存中的引用。[[12\]](#fn12)

由于这种方式，两种语言都有很强的组合型，意思是说，在一个项目的生命周期中，不用去操作、扩展、插入庞大的继承树。这对于长时间运作的大项目来说，是个大福音。

这里最大的区别是，Go 语言里，模板[[13\]](#fn13) 被定义在函数之外，用来复用，但如果没有组织好的话，可能会导致很多重复的接口。而 Elixir 没有办法这么容易的复用模板，但这样模板就一直定义在它使用的地方，不会乱。[[14\]](#fn14)

Elixir 是[强类型](https://link.jianshu.com?t=https%3A%2F%2Fhexdocs.pm%2Felixir%2Ftypespecs.html)的，但不是静态类型的。大多数时候，是通过类型隐式推断来判断类型的。Elixir 里面没有运算符重载，当你想用 `+` 来串联两个字符串的时候，一开始就会比较困惑，因为在 Elixir 里，应该用 `<>`。

如果你不理解背后的缘由的话，这种设定看起来好没劲。编译器能用明确指定的运算符来推断 `+` 的两边都是数字，类似的，`<>` 两边都必须是字符串。

强类型基本上意味着，通过使用 [Dialyzer](https://link.jianshu.com?t=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DJT0ECYZ9FaQ)，除了一些在模式匹配里有歧义的参数之外，编译器几乎可以捕获所有类型。在这些例外情况下，可以使用代码注释来定义变量类型。这样做的好处是，在不丢失动态类型的灵活性的和元编程的特权的同时，享受静态类型的大多数好处。

Elixir 文件可以用 .ex 扩展名表示需要编译的代码文件，.exs 扩展名表示边编译边执行的脚本文件(就像 shell 脚本等一样)。Go 是一直需要编译的，但是 Go 的编译器太快了，即使编译巨大的代码库，感觉也是瞬间完成。

### 并发

并发是比较的重点，现在你已经对编程风格有了一个基本轮廓的了解，所以接下来将更容易理解一些。
 传统上，并发是通过线程来实现的，但线程比较“重”。最近，各种编程语言开始使用“轻量的线程”或者叫“绿色的线程”，并使用存在于单线程里的调度器 轮流调度不同的逻辑。

这种并发模型让内存使用更加高效，但这依赖 runtime 来规定调度的流程。JavaScript 已经在浏览器里使用这种模式很多年了。一个简单的例子：当你听到 JavaScript 的 “非阻塞式 I/O” 时，就意味着，那个线程里执行的代码，会在 I/O 开始时，把控制权让渡给调度器，以让调度器做一些其他的事情。

#### 合作式 vs. 抢占式 调度

Elixir 和 Go 都使用调度器来实现各自的并发模型。虽然这两种语言天生都会将任务均分到多处理器上，但 JavaScript 不行。

Elixir 和 Go 是用不同的方法实现并发的。Go 使用的是合作式的调度，这意味着，当前正在运行的代码必须主动让出控制权，另一个操作才能获得被调度的机会。而 Elixir 使用的是抢占式调度，每个进程都会被预置一个执行窗口，这是被强制保证的，任何情况下都如此。

在性能方面的表现上，合作式调度更高效，因为抢占式调度在强制保证执行窗口时，产生了额外的执行损耗。抢占式调度更稳定(Shawn: 是说表现稳定，不是工作稳定。比如，在吞吐量上，抢占式调度表现更稳)，意思是说，不会因为一个大而耗时的操作一直不释放控制权，而推迟数以百万级的小操作的调度。

作为预防措施，Go 程序员可以通过在代码里插入 `runtime.Gosched()` 来更频繁的(主动)归还CPU控制权, 来应对这种潜在的代码问题。(Elixir 的)运行时级别的保证让第三方库和软实时系统的可信度更高。

#### Goroutine vs. 轻量进程

为了在 Go 里执行并发操作，我们用 Goroutine，就是简单的在一个方法前面加上一个 `go` 关键字，任何方法都行。所以这样：

```go
hello("Bob")
// To...
go hello("Bob")
```

这方面 Elixir 与之差不多，它不用 Goroutine，但你可以 `spawn` 一个 进程（澄清一下：不是操作系统的那种进程，以后所说的进程都是轻量进程）出来。

```elixir
# From...
HelloModule.hello("Bob")
# To...
spawn(HelloModule, :hello, ["Bob"])
# Or by passing a function
spawn fn -> HelloModule.hello("Bob") end
```

这里主要的不同是，`go` 操作什么都没有返回，而 `spawn` 返回了新创建的进程的 id.
 两个体系的进程间通信风格相似，都使用“消息队列”来通信。Go 语言里称其为 “ channel”，Elixir 里叫它 “进程信箱”。

在 Go 语言里可以定义一个 channel，只要有这个 channel 的引用，任何进程都可以给 channel 发消息。在 Elixir 里，可以通过“进程ID”或者“进程名”来给进程发消息。Go 的 channel 在定义的时候给消息指定了数据类型，而 Elixir 的进程信箱用的是模式匹配。

给一个 Elixir 进程发消息，等同于给一个 Goroutine 监控下的 channel 发送消息。这里给出个例子：
 [go channel](https://link.jianshu.com?t=https%3A%2F%2Fgobyexample.com%2Fchannels):

```go
messages := make(chan string) // Define a channel that accepts strings

go func() { messages <- "ping" }() // Send to messages

msg := <-messages // Listen for new messages
fmt.Println(msg)
```

[Elixir process mailbox](https://link.jianshu.com?t=http%3A%2F%2Felixir-lang.org%2Fgetting-started%2Fprocesses.html%23send-and-receive%5D)

```elixir
send self(), {:hello, "world"}
receive do
  {:hello, msg} -> msg # This reciever will match the pattern
  {:world, msg} -> "won't match"
end
```

另外，两者都有办法设置接收消息的超时时间。

由于 Go 是允许内存共享的，Goroutine 也可以直接改变一个内存中的 (channel) 引用，虽然这时必须使用互斥锁来防止竞态条件。比较理想方式是， 一个 channel 上，应当只有一个 goroutine 监听并更新其共享的内存，以避免互斥锁的需求。

在这个(基础)功能之外，好戏才刚刚开始。

Erlang OTP 提供了一系列 使用并发和分布式的 “最佳做法” 的模板(叫设计模式也行)。在 Elixir 里，多数情况下你不会直接去碰 `spawn`, `send/receive` 这些基础函数，一般我们都用这些抽象提供给我们的功能。

这些封装包括 `Task`，用来做简单的 `async/await` 风格的调用。`Agent` 用来使用并发的进程来维护和更新共享的状态。`GenServer` 用来做更复杂的逻辑。等等。

为了限制一个队列上的并发数，Go 的 channel 实现了接收指定数量消息的 buffer (达到上限时，阻塞发送者)。默认情况下，在有进程准备好接收消息之前，channel 一直被阻塞，除非设置了 buffer。

Elixir 的信箱默认是不限制消息数量的，但可以使用 `Task.async_stream` 来定义一个操作的并发数，然后跟 Go channel 一样的阻塞发送者。

进程在 Elixir 和 Go 里都很轻量，一个 goroutine 差不多 2KB，而一个 elixir 进程差不多 0.5KB。Elixir 进程有自己的独立内存，在进程结束时自动回收，而 goroutine 使用共享内存，资源回收要使用应用程序级别的垃圾回收。

#### 错误处理

这可能是两者间的一个最大的区别。Go 语言在各个层级非常显示的做代码处理，从函数调用到 panic. 但在 Elixir 里，错误处理被当做一种 "code smell" [[15\]](#fn15)。我等你一小会儿，你再把这句话读一遍。

那么这是怎么做到的呢？还记得刚才我们谈到，Elixir 的 `spawn` 返回了一个 进程 ID 吧？它可不仅仅是用来发送消息的。它也可以被用来监视那个进程，并且检查它是否还活着。

因为进程太轻了，所以 elixir 里标准的的做法是创建俩。一个就是那个进程，另一个用来监控这个进程。这种方式叫做 supervisor 监控模式。Elixir 应用倾向于工作在监控树之下。监控者在后台使用另外一个方法 `spawn_link` 来创建进程，如果进程崩溃了，监控者就去重启它。

这里有个[使用受监控的进程做除法运算的简单示例](https://link.jianshu.com?t=https%3A%2F%2Fgithub.com%2Fkblake%2Fsimple-supervision).

除0 的运算把进程搞崩了，supervisor 马上重启它，让后面的操作得以正常执行。用 supervisor 就简单直接的实现了这个功能。

相反的，Go 没有办法跟踪单个 Goroutine 个体的执行[[16\]](#fn16)。错误处理必须在各个层次显示的进行，导致了许多这种的代码：

```go
b, err := base64.URLEncoding.DecodeString(cookie)
if err != nil {
  // Handle error
}
```

这里我们指望着在错误可能发生的地方都有错误处理，不论是不是在 goroutine 里面。

Goroutine 可能会将错误情形用同样的方式传给 channel。然而，如果 panic 发生了，每一个 Goroutine 都要保证满足自己的恢复条件，要不然整个应用程序都会崩。Panic 不等同于其他语言里的“异常”，因为 Panic 基本上都是系统级的 “stop everything” 的事件[[17\]](#fn17)。

内存溢出错误可以完美的概括这种情形，如果一个 goroutine 触发了一个内存溢出的错误，即使有着适当的错误处理，整个 Go 程序都会崩，因为内存状态是共享的。

Elixir 里，因为每个进程都有自己的堆空间，可以对每个进程设置堆大小，达到这个限制的话会挂掉这个进程，但然后，Elixir 会独立的垃圾回收那个进程的内存，然后重启它，而不会影响其他任何东西。
 这不是说 Elixir 刀枪不入，VM 本身也可能会因为其他的问题内存溢出，但在进程里的话，这是个可控的问题。

这也不是在批评 Go，这是一个几乎所有的、使用共享内存的语言的通病 -- 意思是说，几乎每一个、你听说过的语言。这是 Erlang/Elixir 设计上的一个强项。

Go 的策略迫使在每一个可能出错的位置处理错误，这需要一个清晰的设计思想，并且可能促使一个经过深思熟虑的应用的诞生。

如 [Joe Armstrong](https://link.jianshu.com?t=https%3A%2F%2Ftwitter.com%2Fjoeerl) 所说，关键点在于，Elixir 模式是，你可以预期其永远不会停的应用程序。你也可以通过 [suture library](https://link.jianshu.com?t=http%3A%2F%2Fwww.jerf.org%2Firi%2Fpost%2F2930) 手动实现一个 Go 版的 supervisor，因为你可以手动调用 Go 的调度器。

注意：在大多数 Go 的 Web server 里，panics 在 handlers 里已经被解决了。所以，一个 web 请求还没有严重到足以让整个应用挂掉的程度，不会的。当然在你自己的 Goroutine 里面还是得自己处理 panic。不要让我的陈述暗示 Go 很脆弱，因为它不脆弱。

#### 可变 vs. 不可变

对于比较 Elixir 和 Go 来说，理解 数据可变 vs. 不可变 之间的权衡很重要。

Go 使用了多数程序员熟悉的内存管理风格：有共享内存，指针，可以被改变和重新赋值的数据结构。对于传递大的数据结构来说，这将会高效很多。

不可变的数据利用了 Copy-On-Write 技术。意思是说，在相同的栈空间里(Shawn: 同一个进程里)，数据传递其实只是传了指向数据的指针而已，只有想改动那个数据的时候，底层才 Copy 一个副本出来让你改。

举个例子来说，一个由很多数据组成的列表，其实可能只是一个包含了 指向那些不可变数据的指针 的列表而已。而对这个列表排序，可能只是返回了一个顺序不同的指针列表，因为那些被指向的数据本身可以认定是不可变的。改变列表中的某个数据的值，将得到一个新的指针列表，其中包含了刚才被修改的那个数据的指针 (当然是个新地址了，原数据没动)。但是当我把这个列表传递给另外一个进程的时候，整个列表包括其中的值都会被 Copy 到新的栈空间。

#### 集群

由可变数据 vs. 不可变数据引出的另外一个问题是集群。

使用 Go 语言，只要你想，你是有办法实现一个无缝的 RPC 的。但是由于指针和共享内存，如果你调用一个远程方法，并传了一个指向本地资源的引用的话，它不会正常工作的[[18\]](#fn18)。

在 Elixir 里面，所有的操作都是通过消息传递的。整个应用程序可以做成任意数量节点的集群。数据被传给一个函数，而这个函数返回一个新值。任何函数的调用都不会引起内存内的数据改动，这允许 Elixir 在调用不同栈空间里的函数、不同机器上的函数 或不同数据中心里的函数时，跟调用本栈空间里的函数的方式一模一样。

很多应用程序是不需要集群的，但是也有很多应用因为集群受益匪浅。比如聊天程序，用户可能连接到了不同的服务器上，他们之间需要通信。或者水平分布的数据库。这两种场景是 Phoenix 框架和 Erlang Mnesia 的常见应用案例。对于那些不使用产生瓶颈的中继节点的应用程序来说，集群是他们水平伸缩能力的关键。

#### 工具库

Go 有个 [可扩展的标准库](https://link.jianshu.com?t=https%3A%2F%2Fgolang.org%2Fpkg%2F)，让大多数开发者不用去找第三方库，几乎就能做任何事情。

[Elixir 标准库](https://link.jianshu.com?t=https%3A%2F%2Fhexdocs.pm%2Felixir%2FKernel.html) 更精简一些，但它包含了更全的 [Erlang 标准库](https://link.jianshu.com?t=http%3A%2F%2Ferlang.org%2Fdoc%2Fapps%2Fstdlib%2Findex.html) ，Erlang 标准库包含了三个预置的数据库 [ETS/DETS/Mnesia](https://link.jianshu.com?t=https%3A%2F%2Fblog.codeship.com%2Felixir-ets-vs-redis%2F)，其他的软件包必须从第三方库拉取。

Elixir 和 Go 都有无数的第三方库可以用，Go 直接使用 `go get` 来从远程导入软件包，而 Elixir 使用  [Mix](https://link.jianshu.com?t=http%3A%2F%2Felixir-lang.org%2Fgetting-started%2Fmix-otp%2Fintroduction-to-mix.html)。Mix 是一个编译工具，它用一种大多数编程语言的用户习惯的方式，调用 Hex 包管理工具。

Go 仍然在努力统一 整个语言范围内的包管理解决方案。在包管理解决方案 和 可扩展的标准库之间，只要能用标准库，多数 Go 社区的人似乎还是喜爱用标准库。已经有很多 [包管理工具](https://link.jianshu.com?t=https%3A%2F%2Fgithub.com%2Fgolang%2Fgo%2Fwiki%2FPackageManagementTools) 可以用了。

#### 部署

Go 的部署简单明了。一个 Go 程序可以编译成一个单独的可执行文件，所有的依赖都包含在里面。然后可以本地化的执行。跨平台的，各种地方都能跑 (编译的时候预先指定目的机器的架构类型)。Go 的编译器可以为任何目标架构编译可执行文件，而不管你的当前运行 Go build 的机器是什么架构的。这是 Go 的大强项。

Elixir 其实有很多部署方式，但最主要的方式还是通过优秀的 [distillery](https://link.jianshu.com?t=https%3A%2F%2Fhexdocs.pm%2Fdistillery%2Fgetting-started.html) 工具来部署。它把你的 Elixir 应用以及所有依赖打包成一个可执行文件，然后可以部署到目标机器上。

两种语言的最大区别是，Elixir 编译环境的 架构类型 必须跟 目标机器的架构类型一样。官方文档里有很多关于这种情形的变通解决方案，但最简单的一种，是在一个跟目标机器相同的 Docker 容器环境里编译发布包。

有了上述两种方式，你可以直接停掉当前运行的代码，然后替换掉可执行文件，然后重启，就像多数今天的 Blue-Green [[19\]](#fn19) 部署方式那样。

#### 热更新

Elixir 还有 BEAM 带来的另外一种部署方法。这东西有点复杂，但对于某些特定类型的应用，好处非常大。叫做 “热加载” 或者 “热升级”。

Distillery 工具基于这个功能出发，简化了这个过程，你只需要在编译发布版时，在你的命令行里加上 `--upgrade` 标志。但这不代表任何情况下你都需要它。

在讨论什么情况下使用它之前，你需要先理解它是做什么的。

Erlang 最开始是给电话系统(OTP 的意思是 Open Telecom Platform) 使用的。目前这个星球上有近一半的电话系统是用 Erlang 的。Erlang 被设计为 “永不停止” 的语言。当有很多通话正在使用着你的系统的时候，“永不停止” 在部署的时候是个很复杂的问题。

如果不断开所有人的连接，你怎么部署呢？难道你需要先阻止所有新打进来的电话，然后礼貌的等待正在进行中的通话结束吗？

答案是不。这就是“热加载”的来由。

由于 Erlang 进程之间的栈空间隔离，升级可以不打断现有的进程。没跑起来的进程可以被替换掉，新启动的进程接收处理新的网络数据，并跟老进程一起并肩运行。正在跑的老进程可以一直干活，直到他们的工作完成。

这允许你再数百万通话正在进行的时候，部署升级。不打断老的通话，让他们自己结束。你可以想想一下你吹泡泡的时候，新的泡泡慢慢替代掉了天空中的老泡泡 ... 基本上热更新也是这样子的原理，老的泡泡仍然在飞来飞去，直到破灭。

理解了这个东西，我们可以看一下热更新比较合适的潜在应用场景：

- 聊天程序。每个用户使用 WebSocket 连接到指定的机器上。
- 任务服务器。你希望在不影响正在运行的任务的同时做更新部署。
- CDN服务器。在一个很慢的网络连接上，一个小的网络请求后面跟着一大堆正在进行的转发包。

拿 WebSocket 来说，这允许你更新一个可能有着百万活动连接的机器，而不会导致数以百万计的重连请求来轰炸服务器，也不会丢失正在发送中的消息。顺便说一句，这就是为啥 WhatsApp 是基于 Erlang 的。热更新已经被用于，在飞机飞行的过程中，更新航天系统。

缺点是，如果你需要回滚的话，热更新会更复杂。只有当你真的有场景需要它的时候，才应该用热更新。但是你知道你有办法做热更新，这挺好的。

集群也是一样，你不一定总是需要它，但是一旦用到了，它就是必不可少的。集群和热更新与分布式系统携手同行。

## 结论

这篇文章很长，但希望它给了你一个对 Go 和 Elixir 之间差异的真切的轮廓。我发现一个最好的办法理解他们的差异：把 Elixir 想象成一个操作系统，而把 Go 想象成特殊程序。

在设计一个 特别快速、目的相当明确的解决方案时，Go 表现非常优异。Elixir 提供了一个环境，在其中很多不同的程序共存、运行、互相交流 (哪怕是在部署更新的时候)。你将用 Go 构建单独的微服务个体。你将在一个单独的 Elixir [umbrella](https://link.jianshu.com?t=http%3A%2F%2Felixir-lang.org%2Fgetting-started%2Fmix-otp%2Fdependencies-and-umbrella-apps.html%23umbrella-projects) 项目里构建很多个微服务。

学习 Go 语言相对明确、简单些。Elixir 的话，你一旦掌握了其窍门儿，就非常直白了。但是如果你的目标是在使用之前全学完的话，浩瀚的 Erlang 和 OTP 的世界会挺吓人的。

两者都是在我的推荐清单里的优秀的编程语言，几乎可以做任何编程里的事情。

对于非常特定的代码，可移植的系统层级的工具，对性能敏感的任务、API, Go 很难被超越。对于 [全栈的网络应用](https://link.jianshu.com?t=http%3A%2F%2Fwww.phoenixframework.org%2F)，分布式系统，实时系统，和 [嵌入式应用](https://link.jianshu.com?t=http%3A%2F%2Fnerves-project.org%2F)，我将会使用 Elixir。

```
Finished! 2018年02月12日18:21:23
```

------

1. Golang 好像是在09年出来，我当时在读大二，当时同学在对我们讲其“令人震惊”的特性时，我是没多大感触的。Elixir 应该是 2014 才发布的，我在学习Erlang的时候第一次被同事安利。 [↩](#fnref1)
2. 比如，用 Golang 写各种移动平台的 Push Provider，从消息队列里读取消息，然后转发到小米，华为，GCM, APNS。用 Elixir 写 WebServer, 提供 RESTful API。 [↩](#fnref2)
3. 当年也是 Docker 爆发的一年。 [↩](#fnref3)
4. 所以 Node.JS 会大行其道! [↩](#fnref4)
5. 是的就是PHP ... 这种倾向也很容易解释：当我们秉持某种信念的时候，我们会自动的摒弃和忽略相反的观点，而只接受相同的观点。所以通过网络搜索“xxx好不好”的问题，除了让我们的执念加深之外，并无用处 -- 人性的弱点如此。 [↩](#fnref5)
6. Shawn：平台指的是诸如 i386, x86_64 这种CPU架构，编译 Go 程序时，可以指定目标操作系统的架构。如 [https://www.digitalocean.com/community/tutorials/how-to-build-go-executables-for-multiple-platforms-on-ubuntu-16-04](https://link.jianshu.com?t=https%3A%2F%2Fwww.digitalocean.com%2Fcommunity%2Ftutorials%2Fhow-to-build-go-executables-for-multiple-platforms-on-ubuntu-16-04) [↩](#fnref6)
7. Shawn：其实说的主要就是 C++。Go 的开发者之一 Ken Thompson 接受采访时有一句话，说他们不喜欢 C++ (一方面原因是过于复杂)。"Yes. When the three of us [Thompson, Rob Pike, and Robert Griesemer] got started, it was pure research. The three of us got together and decided that we hated C++." [↩](#fnref7)
8. Shawn: run-time 或者直接叫 runtime。运行时系统, 或者叫运行时环境。指的是那个提供诸如垃圾回收，线程、进程调度等基础功能的系统。一般情况情况下，说 "Java 的 runtime " 就指的是 Java VM。而 Erlang 的 runtime 指的是 Erlang BEAM VM。Go 没有虚拟机，但 Go 也有提供上述功能的 runtime. Go 的 runtime 在 Go 程序编译时，编译到那个可执行文件里面了，有点类似于 C 的 libc。 [↩](#fnref8)
9. Shawn: 意思就是说不支持像 `for (int i = 0, i < 100; i ++) {// do something;}` 这种的操作，因为 "i" 是不能变的, i++ 这种操作是不允许的。 [↩](#fnref9)
10. Shawn: 不大理解的话，你可以去查查 “尾递归”。 [↩](#fnref10)
11. Shawn: 好像是有那么点意思，但 Elixir 的模式匹配显然要强大多了。Go 的 interface 大概只能在实现多态调用的时候用。而 Elixir 的模式匹配随处可见，匹配函数，匹配case分支，强制赋值(let it crash!)，各种地方都在用。 [↩](#fnref11)
12. Shawn: 我觉着这是 Go 语言设计时没考虑清楚的地方。Go 语言的函数在使用上很有点函数式的样子，但却不支持不变的变量，函数调用也允许程序员随意的更改共享的全局变量。这种允许会怂恿程序员使用全局变量，让处理副作用变得很困难。并且函数的调用方式也很乱，有时候 `g.area()`, 有时候 `area(g)`, 仅仅通过函数的调用方式上，完全看不出 `area` 函数有没有偷偷的改动 `g` 本身的数据。 [↩](#fnref12)
13. Shawn: Go里是通过接口来匹配，所以这里说的模板就是指接口。 [↩](#fnref13)
14. Shawn: 不大赞同这种比较。Go 里面的 interface 应该相当于 Elixir 里的 protocol。Interface 跟 protocol 的作用是相似的，用起来差不多，扩展性也差不多好。硬说 Go 里的 interface 是一种模式匹配的话，也行，但要跟 Elixir 的模式匹配来比较就有点牵强，他们不是一码子事儿。 [↩](#fnref14)
15. Shawn: 代码异味，意思是说代码里的那些，暗示了更深层次问题的表象。 [↩](#fnref15)
16. Shawn: 有个 [Go 版的 supervisor tree](https://link.jianshu.com?t=https%3A%2F%2Fgithub.com%2Fthejerf%2Fsuture)，不知道多少人用过，效果怎样。 [↩](#fnref16)
17. Shawn: 搞不大明白这个说法，我理解 Go 里的 Panic 基本上跟其他语言里的 Exception 差不多。唯一不同的是 Try/Catch 是分支结构，一个函数里可以写很多个。但 panic()/defer()/recover() 是函数层级的，一个函数里只能有一个。 [↩](#fnref17)
18. Shawn: 当然还有其他问题的。比如远程方法调用和本地调用的出错模式不一样，一个走网络，一个走内存。你要是调用一个本地的方法，马上就执行完了；如果调用的是远程的一个方法，可能几毫秒还没完。并且远程方法可能由于各种原因(比如网络超时)挂掉。这种情况下，你如果把 RPC 调用跟普通的 函数调用同等处理的话，那些远程的调用可能会出一些隐藏的bug。在 Erlang 里，所有进程间调用，不管是不是调用了远程还是本地的函数，处理起来一模一样。 [↩](#fnref18)
19. Shawn: 假设有一个程序的两个不同的版本：老版本 Blue，新版本 Green。在做升级部署的时候，可以先把通往 Blue 的所有网络信令都路由给 Green，如果出了问题马上再切换回来。 [↩](#fnref19)

作者：Shawn_xiaoyu

链接：https://www.jianshu.com/p/b59677547b26

来源：简书

简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
