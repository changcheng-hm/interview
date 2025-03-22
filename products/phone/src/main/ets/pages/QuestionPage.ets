import { HcLoadingDialog, HcNavBar, HcTag, httpInstant, QuestionOptParams } from '@cc_interview/basic';
import { QuestionDetail, QuestionPageParams, QuestionShareDialog } from '@cc_interview/home';
import { promptAction, router } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
@Entry
@Component
struct QuestionPage {
  list: QuestionDetail[] = [];
  @StorageProp('bottomHeight') bottomHeight: number = 0

  @State item: QuestionDetail = {} as QuestionDetail

  @State questionIndex: number = 0

  controller = new webview.WebviewController()

  dialog = new CustomDialogController({
    builder: HcLoadingDialog(),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  shareDialog = new CustomDialogController({
    builder: QuestionShareDialog({ item: this.item }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  async questionOpt(optType: 1 | 2, flag: 0 | 1) {
    try {
      const data: QuestionOptParams = {
        id: this.item.id,
        type: 0,
        optType
      }
      // flag 是你要执行的操作 执行 | 取消
      await httpInstant.request<null, QuestionOptParams>({
        url: flag === 1 ? 'question/opt' : 'question/unOpt',
        method: 'post',
        data
      })
      if (optType === 1) {
        this.item.likeFlag = flag
        promptAction.showToast({ message: flag ? '点赞成功' : '取消点赞' })
      }
      if (optType === 2) {
        this.item.collectFlag = flag
        promptAction.showToast({ message: flag ? '收藏成功' : '取消收藏' })
      }
    } catch (e) {
      promptAction.showToast({ message: '操作失败' })
    }
  }

  async toggleQuestion(step: number) {
    const index = this.questionIndex + step
    if (index < 0 || index >= this.list.length) {
      return promptAction.showToast({ message: '没有更多题了' })
    }
    this.questionIndex = index
    const item= this.list[index]
    // 加载试题，如果数组中已经是完整数据，直接使用，否则加载
    if (item.answer) {
      this.item = item
    } else {
      const fullItem = await this.getQuestionDetail(item.id)
      this.list[index] = fullItem
      this.item = fullItem
    }
    this.controller.runJavaScript(`writeHtml(\`${this.item.answer}\`)`)
  }

  async aboutToAppear() {
    const params = router.getParams() as QuestionPageParams
    if (params) {
      this.item = params.item as QuestionDetail
      this.list = params.list as QuestionDetail[]
      // 如果 item 不是完整数据才加载
      if (!this.item.answer) {
        this.questionIndex = this.list.findIndex(item => item.id === this.item.id)
        this.item = await this.getQuestionDetail(this.item.id)
        this.list[this.questionIndex] = this.item
      }
      this.controller.loadUrl($rawfile('question.html'))
    }
  }

  aboutToDisappear(): void {
    this.dialog.close()
  }

  async getQuestionDetail (id: string) {
    this.dialog.open()
    const res = await httpInstant.request<QuestionDetail>({ url: `question/${id}` })
    this.dialog.close()
    return res
  }

  @Builder
  TitleBuilder(text: string) {
    Row() {
      Text()
        .width(2)
        .height(12)
        .backgroundColor($r('app.color.black'))
        .margin({ right: 13 })
      Text(text)
        .fontWeight(700)
    }
    .width('100%')
    .padding({ top: 10 })
    .height(32)
  }

  @Builder
  MenuBuilder() {
    Menu() {
      MenuItem({ content: this.item.likeFlag === 1 ? '取消点赞' : '点赞' })
        .onClick(() => this.questionOpt(1, this.item.likeFlag === 1 ? 0 : 1))
      MenuItem({ content: this.item.collectFlag === 1 ? '取消收藏' : '收藏' })
        .onClick(() => this.questionOpt(2, this.item.collectFlag === 1 ? 0 : 1))
      MenuItem({ content: '点我反馈' })
      MenuItem({ content: '试题分享' })
        .onClick(() => this.shareDialog.open())
    }
    .width(108)
  }

  build() {
    Column() {
      HcNavBar({ title: '试题详情', showRightIcon: false })
      // 题目
      this.TitleBuilder('题目：')
      Text('ArkUI的容器组件有哪些？')
        .width('100%')
        .padding(16)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Row({ space: 12 }) {
        HcTag({ text: 'HarmonyOS' })
        HcTag({ text: 'ArkTS', color: '#ff6600' })
        Blank()
        Image($r("app.media.ic_home_more"))
          .width(20)
          .aspectRatio(1)
          .bindMenu(this.MenuBuilder())
      }
      .width('100%')
      .padding({ bottom: 16, left: 16, right: 16 })

      Divider()
        .strokeWidth(8)
        .color($r('app.color.common_gray_bg'))
      // 内容
      // 内容
      this.TitleBuilder('答案：')

      Web({ src: $rawfile('question.html'), controller: this.controller })
        .width('100%')
        .layoutWeight(1)
        .onPageEnd(() => {
          if (this.item.answer) {
            this.controller.runJavaScript(`writeHtml(\`${this.item.answer}\`)`)
          }
        })

      Row({ space: 80 }) {
        Row() {
          Image($r('sys.media.ohos_ic_public_arrow_left'))
            .width(20)
            .aspectRatio(1)
            .fillColor(this.questionIndex <= 0 ? $r('app.color.common_gray_01') : $r('app.color.common_gray_03'))
          Text(' 上一题')
            .fontColor(this.questionIndex <= 0 ? $r('app.color.common_gray_01') : $r('app.color.common_gray_03'))
        }
        .onClick(() => {
          this.toggleQuestion(-1)
        })

        Row() {
          Text('下一题 ')
            .fontColor(this.questionIndex >= this.list.length-1 ? $r('app.color.common_gray_01') : $r('app.color.common_gray_03'))
          Image($r('sys.media.ohos_ic_public_arrow_right'))
            .width(20)
            .aspectRatio(1)
            .fillColor(this.questionIndex >= this.list.length-1 ? $r('app.color.common_gray_01') : $r('app.color.common_gray_03'))
        }
        .onClick(() => {
          this.toggleQuestion(1)
        })

      }
      .height(44)
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .padding({ bottom: this.bottomHeight })
  }
}