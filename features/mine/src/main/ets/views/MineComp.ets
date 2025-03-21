@Component
export struct MineComp {
  build() {
    Column() {
      Text('Mine')
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}