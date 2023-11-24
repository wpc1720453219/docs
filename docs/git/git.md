## 分支管理  
### master 分支    
master 为主分支，主分支，永远处于稳定状态，对应当前线上版本    
以 tag 标记一个版本，因此在 master 分支上看到的每一个 tag 都应该对应一个线上版本    
master 分支一般由 develop 以及 hotfix 分支合并，任何时间都不能直接修改代码，不允许在该分支直接提交代码    
### develop 分支  
develop 为开发分支，始终保持最新完成以及 bug 修复后的代码 , 包含了项目最新的功能和代码，    
所有开发都依赖 develop 分支进行  
一般开发的新功能时， feature 分支都是基于 develop 分支下创建   
小的改动可以直接在 develop 分支进行，改动较多时切出新的 feature 分支进行    
推荐的做法 : develop 分支作为开发的主分支，也不允许直接提交代码。  
小改动也应该以 feature 分支提 merge request 合并，目的是保证每个改动都经过了强制代码 review ，降低代码风险      
### feature 分支  
feature 分支  
分支命名 : feature/ 开头的为特性分支， 命名规则 : feature/user_module 、 feature/cart_module  
开发新功能时，以 develop 为基础创建 feature 分支  
开发新的功能或者改动较大的调整，从 develop 分支切换出 feature 分支，分支名称为 feature/xxx    
开发完成后合并回 develop 分支并且删除该 feature/xxx 分支  
### release 分支   
发布分支，新功能合并到 develop 分支，准备发布新版本时使用的分支 , 预发布   
发布之前发现的 bug 就直接在这个分支上修复，确定准备发版本就合并到 master 分支，完成发布，同时合并到 develop 分支    
当有一组 feature 开发完成，首先会合并到 develop 分支，当 develop 分支完成功能合并和部分   
bug fix ，准备发布新版本时或者进入提测时，会创建 release 分支如果测试过程中若存在 bug 需要  
修复，则直接由开发者在 release 分支修复并提交。当测试完成之后，合并 release 分支到 master 和  
develop 分支，此时 master 为最新代码，用作上线  
### hotfix 分支  
分支命名 : hotfix/ 开头的为修复分支，它的命名规则与 feature 分支类似  
当线上版本出现 bug 时，从 master 分支切出一个 hotfix/xxx 分支，完成 bug 修复，然后将  
hotfix/xxx 合并到 master 和 develop 分支 ( 如果此时存在 release 分支，则应该合并到 release  
分支 ) ，合并完成后删除该 hotfix/xxx 分支  
以上就是在项目中应该出现的分支以及每个分支功能的说明。 其中稳定长期存在的分支只有 master 和  
develop 分支，别的分支在完成对应的使命之后都会合并到这两个分支然后被删除。简单总结如下：  
master 分支 : 线上稳定版本分支  
develop 分支 : 开发分支，衍生出 feature 分支和 release 分支  
release 分支 : 发布分支，准备待发布版本的分支，存在多个，版本发布之后删除  
feature 分支 : 功能分支，完成特定功能开发的分支，存在多个，功能合并之后删除  
hotfix 分支 : 紧急热修复分支，存在多个，紧急版本发布之后删除  





