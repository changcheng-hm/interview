@Component
export struct ProjectComp {
  build() {
    Column() {
      Text('Project')
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}