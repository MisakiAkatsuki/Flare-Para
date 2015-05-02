#########
######
###
# Flare and Para
#   あかつきみさき(みくちぃP)

# このスクリプトについて
#   フレア/パラを追加するスクリプトです.
#   各種パラメーターを指定し,Applyで新規レイヤーとして追加します.
#   エフェクトには「描画」カテゴリの「グラデーション」を使用しています(CS6以前ではエフェクト名がカラーカーブですが,機能は同一のものです).

#   エフェクトにグラデーションが適用されている場合,対象のレイヤーを最後に選択した状態で各種パラメーターを操作することができます.

#   ・色
#     フレア・パラの色を指定します.
#   ・不透明度
#     レイヤーの不透明度を指定します.
#   ・モード
#     合成モードを指定します.パラの場合は乗算,フレアの場合はスクリーンになります.
#   ・グラデーションのシェイプ
#     グラデーションの形状を指定します.
#   ・グラデーションの拡散
#     グラデーションの拡散を指定します.
#   ・光源方向
#     光源の方向を8方向+中心から指定します.
#     光源方向が中心の場合は,グラデーションのシェイプが放射状になります.

# 謝辞
#   このスクリプトは以下のものをリメイクするという理念の下に作成しています. 基本的な操作方法やエフェクト追加の概念は以下に基づいています.
#     「アニメ撮影におけるフレア/パラのエフェクトオペレーションを高速化するスクリプトパネル：FP-Launcher」
#     http://ae-users.com/jp/resources/2010/03/%E3%82%A2%E3%83%8B%E3%83%A1%E6%92%AE%E5%BD%B1%E3%81%AB%E3%81%8A%E3%81%91%E3%82%8B%E3%83%95%E3%83%AC%E3%82%A2%E3%83%91%E3%83%A9%E3%81%AE%E3%82%A8%E3%83%95%E3%82%A7%E3%82%AF%E3%83%88%E3%82%AA%E3%83%9A/

#   FP-Launcherとの主な違いについて
#     追加するApplyボタンの追加.
#     色の取得をRGBスライダーとクリックでのピッカー表示にした.
#     使用するエフェクトをグラデーションにした.
#     レイヤーの不透明度に対応.
#     グラデーションの拡散に対応.
#     Undoの改善.

# ライセンスについて
#   MIT License

# 使用方法
#   ScriptUIフォルダーにスクリプトを入れてウィンドウより実行か,スクリプトファイルの実行より実行してください.

# 動作環境
#   Adobe After Effects CS5以上

# バージョン情報
#   2014/05/01 Ver 1.0.0 Release
###
######
#########

###Data###

FPLData = ( ->
  scriptName          = "Flare and Para"
  scriptURLName       = "FlareandPara"
  scriptVersionNumber = "1.0.0"
  scriptURLVersion    = 1.00
  canRunVersionNumber = 10.0
  canRunVersionName   = "CS5"
  guid                = "{AF52B347-CCB6-4014-9012-0F69F0EC185F}"

  return{
    getScriptName         : -> scriptName
    ,
    getScriptURLName      : -> scriptURLName
    ,
    getScriptVersionNumber: -> scriptVersionNumber
    ,
    getScriptURLVersion   : -> scriptURLVersion
    ,
    getCanRunVersionNumber: -> canRunVersionNumber
    ,
    getCanRunVersionName  : -> canRunVersionName
    ,
    getGuid               : -> guid
   }
)()

###class###
class RGBColor
  @BLACK : [0,0,0]
  @WHITE : [1,1,1]

  @RED   : [1,0,0]
  @GREEN : [0,1,0]
  @BLUE  : [0,0,1]

  normalized = (color) ->
    for i in [0...color.length] by 1
      if isNaN(color[i])
        color[i] = 0.0
        continue

      if color[i] > 1.0
        color[i] = 1.0
      else if color[i] < 0.0
        color[i] = 0.0
    return color

  constructor: (colorValue...) ->
    if colorValue? and colorValue instanceof Array
      colorValue = normalized(colorValue)
    else
      colorValue = [0,0,0]

    @setColorValue = (newColor) =>
      colorValue = normalized(newColor)

    @getColorValue = () =>
      colorValue


###prototype###
Button::drawRect = (color) ->
  return unless color instanceof Array
  return if color.length < 3

  @DRAW_MARGINS = 1

  @normalized = (color) ->
    for i in [0...color.length] by 1
      if color[i] > 1.0
        color[i] = 1.0
      else if color[i] < 0
        color[i] = 0.0
    return color

  @reDraw = () ->
    @enabled = false
    @enabled = true
    return

  @fillBrush = @graphics.newBrush(@graphics.BrushType.SOLID_COLOR, @normalized(color))

  @onDraw = ->
    @graphics.drawOSControl()
    @graphics.rectPath(@DRAW_MARGINS, @DRAW_MARGINS, @size[0]-@DRAW_MARGINS*2, @size[1]-@DRAW_MARGINS*2)
    @graphics.fillPath(@fillBrush)

    if @text
      @graphics.drawString @text, @textPen, (@size[0]-@graphics.measureString(@text, @graphics.font, @size[0])[0])/2, 3, @graphics.font
    return

  @reDraw()
  return

Button::drawEllipse = (color) ->
  return unless color instanceof Array
  return if color.length < 3

  @DRAW_MARGINS = 1

  @normalized = (color) ->
    for i in [0...color.length] by 1
      if color[i] > 1.0
        color[i] = 1.0
      else if color[i] < 0
        color[i] = 0.0
    return color

  @reDraw = () ->
    @enabled = false
    @enabled = true
    return

  @fillBrush = @graphics.newBrush(@graphics.BrushType.SOLID_COLOR, @normalized(color))

  @onDraw = ->
    @graphics.drawOSControl()
    @graphics.ellipsePath(@DRAW_MARGINS, @DRAW_MARGINS, @size[0]-@DRAW_MARGINS*2, @size[1]-@DRAW_MARGINS*2)
    @graphics.fillPath(@fillBrush)

    if @text
      @graphics.drawString @text, @textPen, (@size[0]-@graphics.measureString(@text, @graphics.font, @size[0])[0])/2, 3, @graphics.font
    return

  @reDraw()
  return

Property::setValueAtSmart = (time, newValue) ->
  try
    if @hasMax or @hasMin
      if @maxValue < newValue
        newValue = @maxValue
      else if @minValue > newValue
        newValue = @minValue

    if @numKeys is 0
      @setValue(newValue)
    else
      @setValueAtTime(time, newValue)
  catch err
    # writeLn err

    if @numKeys is 0
      @setValue(newValue)
    else
      @setValueAtTime(time, newValue)
  return

###resource###
COLOR_MAX_VALUE = 255

ADBE_TRANSFORM_GROUP = "ADBE Transform Group"
ADBE_OPACITY         = "ADBE Opacity"
ADBE_EFFECT_PARADE   = "ADBE Effect Parade"
ADBE_RAMP            = "ADBE Ramp"
ADBE_MARKER          = "ADBE Marker"

OPACITY_MATCHNAME       = ADBE_OPACITY

START_OF_RAMP_MATCHNAME = "ADBE Ramp-0001"
END_OF_RAMP_MATCHNAME   = "ADBE Ramp-0003"

START_COLOR_MATCHNAME   = "ADBE Ramp-0002"
END_COLOR_MATCHNAME     = "ADBE Ramp-0004"

RAMP_SHAPE_MATCHNAME    = "ADBE Ramp-0005"
RAMP_SCATTER_MATCHNAME  = "ADBE Ramp-0006"

ERR_PICKER = "-1"

LINEAR_RAMP = 1
RADIAL_RAMP = 2

_STRINGS_JP =
  AUTHOR : "あかつきみさき (SUNRISE MOON)"
  HELP   : "フレア/パラを追加するスクリプト.\n謝辞: FP-Launcher"
  FLARE_C: "フレア"
  FLARE_M: "*---フレア---"
  PARA_C : "パラ"
  PARA_M : "*---パラ---"



_STRINGS_EN =
  AUTHOR : "Misaki_Akatsuki (SUNRISE MOON)"
  HELP   : "Add Flare/Para script.\nSpecial thanks: FP-Launcher"
  FLARE_C: "Flare"
  FLARE_M: "*---Flare---"
  PARA_C : "Para"
  PARA_M : "*---Para---"



ARROW_ICON = [
  "\u0089PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\x16\x00\x00\x00\x16\b\x06\x00\x00\x00\u00C4\u00B4l;\x00\x00\x01\u0080IDAT8\u008D\u00ED\u0093\u00B1j\u00C2`\x14\u0085O\u00A2\u00A9\u00A0\u0090\x1FB\u00B3w\x15\u008A!89X\x07Q'\u009D|\u0086\u00F4\t\u00D4\u00DDGp\x11\x07\u009D\\:(\x11\u00C1Qp1\x11q\x14\t\u00BE\u0085\u008A\u0082UO\u00A7\x16J\x1B\u00A5V\u00E8\u00D2\x0F\u00FE\u00E9p?\x0E\u00FF\u00E5\x02\u00FF\u00F8!I\u0092\u00A2\u00EB\u00FA^\u0092$\u00E5\u00A6b!\u00C4s\u00BD^g \x10\u00B8\u00BF\u00A9\u00BC\u00D7\u00EBq\u00B9\\r0\x18|\u0091\x0B!\x1AB\u0088\u00C6U\u00E2x<\u00CE\u00E9tJ\u00CF\u00F3\u00D8\u00EF\u00F7?\u00C9-\u00CB\u00A2eY\u00BC\u00BA\u00B5i\u009A\u009CL&\\,\x16\u00ECv\u00BB\x04 \u0085B\u00A1'\u00DB\u00B6i\u00DB6\u0083\u00C1\u00E0\u00C3\u00AF\u00E4\u008E\u00E3p>\u009F\u00B3\u00D3\u00E90\u0097\u00CB\u00D1u]\u00BA\u00AE\u00CBT*u\u00B1\u00B5tI^\u00AB\u00D5\x10\x0E\u0087\u00B1\u00DDn!\u00CB2\x00\u00C0q\x1C\u0094J\u00A5;\u0092\u00AF~\u00B3\x01\u00BF@\b\u00D1X\u00ADVq\u00CF\u00F3\u0090H$\x00\x00$A\x12\u009A\u00A6a8\x1C>\u00AE\u00D7\u00EB\u0097\x1F7.\u0097\u00CBL&\u0093PU\x15\u00A7\u00D3\u00E9K\u00DEl6\u00D1n\u00B7}\u00E7e\u00DF@\u0096\x11\u0089D\u00A0i\x1ATU\u0085\u00A2(8\x1C\x0E\x1F/\u0093\u00C9\u00E0\u00DC\x12\u00CF\u00FE1\x00\x14\n\x05\x16\u008BED\u00A3Q(\u008A\u0082\u00DDn\u0087\u00CDf\u0083\u00E3\u00F1\u0088j\u00B5\u008A\u00F1x\u00FC\u00AD\u00E3\u00A2\u00F8\x1D\u00D34\u0099N\u00A7\u0091\u00CDf\u00A1\u00EB:\u00F6\u00FB=F\u00A3\x11*\u0095\u00CA\u00D9%\u00FE\u0088|>\u00CFV\u00AB\u00C5\u00D9l\u00C6X,v\u00FD\u00C1\u00F8a\x18\x06\r\u00C3\u00B8\u00BD\u00F8\u009F\u00BF\u00E5\r!\u00D6\u00A8t+\u00DD\x07@\x00\x00\x00\x00IEND\u00AEB`\u0082"
  "\u0089PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\x16\x00\x00\x00\x16\b\x06\x00\x00\x00\u00C4\u00B4l;\x00\x00\x01\x1BIDAT8\u008D\u00ED\u0094=\u00AE\u0082@\x14F\u008F7$\u00DC\u008E\x10X\x04\u008D[\u0090\u00D2\u00CA]\u00B06+*\u0086\u00C6\u0084\u00CA\u00DEF\u00F6`\u00A3\x0B\u00A0p\u00EEX\u00BCh\u00C7_\u00E2\u00EB\u00FC\u00DA\u0099sr\u0086\x02\u00F8m\u00ED\u0092$\tI\u0092\u0084\u00AF\u008B\u00FB\u00BE\x0F}\u00DF/\x16GK/\u009A\u00D9\u00AA\u0090\u00C5b\u00EF\u00FD\u00FF\u0088\u00D7\x16\u00CB\u00E8\u0081H\u009E\u00A6i\u00C8\u00B2\u00EC*\"\u00B9\u00F7\x1E\u00EF=\"\u0092gYvM\u00D34\u0088H\u00BEZ\\\u0096\u00E5\u00BDm[\u00AA\u00AA\u00DA\x16Eq33\u00CC\u008C\u00A2(nUUm\u00DB\u00B6\u00A5,\u00CB\u00FB\x18\u00BF\u0099z\u008Es.\u00E4y\u00CE\u00F3\u00F9d\u00B3\u00F9\u00BB\x1AB \u008A\"\x1E\u008F\x07\u0087\u00C3a\u0094\x1F-\x06\u00A8\u00EB\x1AU\u00C5\u00CCx\x7F\n3CU\u00A9\u00EBz\n\u009D.\x068\u009DN\u00E1-\x07\x10\x11\u0086a`\u00BF\u00DFO\u00B2\u0093\u00C5\x00M\u00D3\x10\u00C7\u00F1\u00A78\u008Ec\u009A\u00A6\u0099\u00C3\u00E6\u008B\x01\u00CE\u00E7s\x18\u0086\x01\x00Ue\u00B7\u00DB\u00CDr\u00B3\u00C5\x00\u00CE9T\x15U\u00C59\u00B7\x04Y\u00BE\u00AE\u00EBB\u00D7u\u00DF\u00FFW\\.\u0097U!\u008B\u00C5\u00C7\u00E3q\u0095\u00F8\u00B7\u00CF^\u00C4\nw\u008Eqne\u00BE\x00\x00\x00\x00IEND\u00AEB`\u0082"
  "\u0089PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\x16\x00\x00\x00\x16\b\x06\x00\x00\x00\u00C4\u00B4l;\x00\x00\x01\u0080IDAT8\u008D\u00ED\u00D2\u00B1j\u00C2P\x14\x06\u00E0\u00FF\u00C6$rE\bBEp\u00F2\x054\u0088 \u00B8\u00D4I\u009C\x04\x1F\u00C0M\u00C8\u00E838\u00EB\x03\u0088\u008B{\u00C1HTpsr0\"\u00E2\x14D\x1C\u008A\u00B3\u009B\u0088\u0083z=\u00DD\u008A\u00B4&\u00C5\u00E0R\u00F0\x1F/\u00DC\u008F\u00FFp\x0E\u00F0\u00CA3\u00C2\x18S\u00A2\u00D1\u00E8\u00891\u00A6<\x15\r\x04\x02o\u00ADV\u008B8\u00E7\u00EF\u00BE\x10M\u00D3\u00DA\u009A\u00A6\u00B5\x7F\u00A2\u00A3\u00D1\u00886\u009B\r\u00F5\u00FB}\u00F2\x05\x1B\u0086A\u0086a\u00D0-:\x1C\x0Ei\u00BD^\u00D3|>\u00A7L&\u00F38,\u00CBr\u00C2\u00B2,\u00B2,\u008B\u0082\u00C1\u00E0;\x00\u00D6\u00EB\u00F5h\u00B5Z\u00D1l6\u00A3t:\u00ED\u00AFm>\u009F'\u00DB\u00B6\u00C9\u00B6m*\x16\u008Bd\u009A&9\u008EC\u00D3\u00E9\u00D4\x13e^(cLi6\u009B\u00A7\\.\x07\x00\u00B8^\u00AF\b\u0085B8\x1E\u008F\u00A8\u00D5jX.\u0097\u00AE\u00FF%/8\x1E\u008F\x7F$\u0093I\b! \u0084\x00\x11\u00E1p8\u00A0^\u00AFc\u00BB\u00DD\u00E2v\u00A1\x0F5\u00AET*T\u00ADV\x7F\u00B7\u0091$\u00EC\u00F7{L&\x134\x1A\u008D\u00BB\u0086\u00EC\u0086\u00CA\u00B2\u009C(\x14\n\u00B8\\.\u00DFo\u009Csp\u00CE\u00A1\u00AA*\u0084\x10\u0090$\u00F7\u0081]\u00E1l6\u00FB\x19\u008B\u00C5\x00\x00\u00E1p\x18\u009Cs\u009C\u00CFg8\u008E\u0083n\u00B7\u008B\u00C1`\u00E09\u00ED]\u00981\u00A6\u0094\u00CBeD\"\x11\u00A8\u00AA\u008A\u00DDn\x07\u00D341\x1E\u008F=\x17\u00F6gR\u00A9\x14-\x16\x0B\u00EAt:T*\u0095\u00FC\u00DD\u00E9\u00BD\u00E8\u00BAN\u00BA\u00AE?\x0F|\u00E5\x7F\u00E5\x0BD\f\u009BR\u00D3R\x02\n\x00\x00\x00\x00IEND\u00AEB`\u0082"
  "\u0089PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\x16\x00\x00\x00\x16\b\x06\x00\x00\x00\u00C4\u00B4l;\x00\x00\x01$IDAT8\u008D\u00ED\u0090\u00BFj\u0083p\x14\u0085\u008FV\u00F0/\u0088D\u0097\x0Ey\x07)\x01\x03\u00A1\u00B8\x1A\u00FA\x04\u00BE@_#\u00E0\u00E0\x1B899\u00B9J\nY39\u008A\u00A1o\u0090\u00C1\u00D1\u0080\u00B8\u0088\u00C8\u00ED\u0096R\u00F3K\u00EB\u0090.m\u00BE\u00F1p\u00EF\u00C7\u00B9\x17\u00B8\u00F3\u00B7\u00E1y\u00DE\u00FC\x15\u00B1\u00E38d\u009A&\u0089\u00A2\u00F8|S\u00F1\u00E1p\u00A0$Ih\u00BD^\u00D3l6#UU_\x7F\u00DAy\u0098\"\u00B6m{\u00B3X,\u00E0\u00BA.\u0096\u00CB%\u0086ax\u00A9\u00AAj#\u008A\u00E2c\u00D7uo\u00AC\x1Dn\x1C\u00E8\u00BAN\u00E3l>\u009F#\u008Ecp\u00DC\u00E7x]\u00D7H\u00D3\x14Y\u0096\u0081\u00E7\u00F9\u00F7\u00BA\u00AE\u009F\u0088\u00A8\u00BF*\u00CE\u00F3\u00FCB|\r\u008E\u00E3\u00D0u\x1D\u008A\u00A2@\u0092$(\u00CB\u00F2\u00EC\x13\u00C6\u00C3\u0086a0%\u00A7\u00D3\t}\u00DF\u009F\u0085\u008A\u00A2@\u0096e\u00B4m\x0BA\x10\u00BE\\\u00C3l\u00CC\u00C2\u00B6m\n\u0082\x00\u00AA\u00AAB\u00D34\u00C8\u00B2\u008C\u00A6i\u00B0\u00DDn\x11\u0086!\u00D3q\u00D1\u0098\u0085\u00E7y\u00B0,\x0B\u0092$\u00E1x<b\u00B7\u00DB!\u008A\u00A2I\u00A5\u00BEe\u00BF\u00DFS\u009A\u00A6\u00E4\u00FB\u00FE\u00E4\u00FFOb\u00B5Z\u00DDVx\u00E7\u009F\u00F2\x01\u009E8^\u0080t\u00B7l?\x00\x00\x00\x00IEND\u00AEB`\u0082"
  "\u0089PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\x16\x00\x00\x00\x16\b\x06\x00\x00\x00\u00C4\u00B4l;\x00\x00\x01\x19IDAT8\u008D\u00ED\u00921\u008A\u0083P\x10\u0086\u00FF\u00F7x\u009A\u0080!A\u00E3\x15R.\b6A\u00C2\u0096\x16\x01\x11\u00ACB\n\u00AB\u00B0\x0B\u00DE@\u00C1\u0083lk\u0095>\x17\u00B0\x13\u008B%x\x05o h\u00EC\u009C\u00AD\x12V\x16\u00C1\u00C2\u00AD\u0092\u00AF\x1B~\u00E6\u009Ba\x18\u00E0\u00C5\u00F3\u00C09\u00D7'\x15\u00CEf\u00B3w]\u00D7i\u00BB\u00DD\u00D2$BEQ>\u00D7\u00EB5\u00ED\u00F7{J\u0092\u0084\u008A\u00A2\x18%\x16C\u00C1j\u00B5\u00FA\u00E2\u009C\x7F\u00D8\u00B6\r\u00CF\u00F3\u00B0\u00D9l \u0084@\u0096e\u00A3\x16b\u00BD\u00821I\u00D3\u00B4\u00EF\u00AE\u00EB\u00DE\\\u00D7\u00C5\u00E1p\u0080\u00A6i\u008F\u009C\u0088p:\u009DP\u0096\u00E5\x1FQUU}\u00D7\u00EF\u00C20\f\u00F2}\x1F\u00A6iB\u0096e\x10\u008D?\u00A7eY=W\u00EF\x14\u008C1\b!0\u009F\u00CF\u00B1X,\u00D0\u00B6-n\u00B7\u00DBc\u0080$IPUu\u00D4 6\x14\u0084aH\u008E\u00E3`\u00B9\\\u00A2m[\u00D4u\u008D\u00A6i\x10\u00C71\u00AE\u00D7\u00EB`\u00DFh\u0082 \u00A0\u00CB\u00E5BEQP\u009E\u00E7\x14E\u00D14\u00EFv\u00E7x<\u00D2\u00F9|\u00A64M\u00A7\x15\u00DF\u00D9\u00EDv\u00FF#~\u00F1\x04\u00FC\x00=\u00E6[\u00EEP\u00B5\u0082H\x00\x00\x00\x00IEND\u00AEB`\u0082"
  "\u0089PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\x16\x00\x00\x00\x16\b\x06\x00\x00\x00\u00C4\u00B4l;\x00\x00\x01\u0086IDAT8\u008D\u00ED\u0092\u00B1\u008E\x01Q\x14\u0086\u00FF;\u00C6\u00BDF\u00CCH$\u00FA\u00AD\u0084D2&\u00AA\u0095(\u00B5\x12Qx\x02j\u00957\u00F0\x06[P \x11\u0085R#\u00C1\u00C4\x03\u00D0\x10Q)\u00BC\u00C0VTb\u00F7\u00CE\u00D9fM\u00C3\u00C8\u00B26\u00D9\u00C2\u009F\u00DC\u00E6\u009E{\u00BF|'\u00E7\x00\u00CF\u00FC\u00EB0\u00C6\u00FC\u008C1\u00FF\u00A5\u009Ar\x0FPU\u00D5\u0097h4z\f\x04\x02\u00AF\u00A9T\u00EA\u00F8k\u00BBp8\u00DC\u008CD\"\u0094\u00CDf\u00A9\u00D1h\u00D0v\u00BB\u00A5t:Mw\x01Ov\x00P\u00A9Th8\x1C\u00D2r\u00B9\u00A4\u00D5jE\u0083\u00C1\u00C0\x13\u00AAz\u00D9\x19\u0086\u00F1\u00E6\u00F3\u00F9*\u0089D\x02\u00A5R\t\u0096eQ0\x18\x04\x00H)!\u0084@\u00AF\u00D7\u00F3\u00EE\u00F0\u00D2e2\u0099t\u00F2\u00F9<\u00CB\u00E5r\u00D0u\x1DR\u00CA\u00B37RJd2\u0099\u008B\u00FF\x01\u008F\u00E1\u00AD\u00D7kEUUp\u00CEa\x18\x068\u00E7p\x1C\u00C7=\u009Cs\u008CF#O[Oc\u00B7\u00C8\u0098\u00BFP(\x1C\u00AB\u00D5*4M\u00C3\u00E1p\x00\x00h\u009A\u0086r\u00B9\u008C\u00C5bq\u009B\u00F1\tJD\u009F\u00C5b\x11\u00BA\u00AE#\x14\n\u00B9\u00B5\u00CDfs\x15\u00EA\t\u00FE\u0086~t\u00BB]'\x16\u008Ba\u00B7\u00DB\u00A1^\u00AFC\b\x01!\x04\u00FA\u00FD\u00FE5\u00A6\u00B7)\x00t:\x1D\u009A\u00CDf4\u009DN\u00C9\u00B2,\x02\x00\u00DB\u00B6\u00C9\u00B6\u00ED\x1F\u00ED\u00ED\u00D9\u00BA)\u008A\x12n6\u009B\u00EF\u00F1x\x1C\u00FB\u00FD\x1E\u00B5Z\u00CDm{2\u0099\u00DCnzJ\u00BB\u00DD\u00A6\u00F9|N\u00E3\u00F1\u00D85}HL\u00D3\u00A4V\u00ABE\u00A6i>\x0E\u00FA\u00CC\u009F\u00E4\x0B:1\u0091\u0090\u00D5\u0085!\u008F\x00\x00\x00\x00IEND\u00AEB`\u0082"
  "\u0089PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\x16\x00\x00\x00\x16\b\x06\x00\x00\x00\u00C4\u00B4l;\x00\x00\x01\x12IDAT8\u008D\u00ED\u0093!n\u00C30\x18F?\u00FFje\x10\u00C91(\u00A9\u00C2B\u0092SX\u00E16)\u0088A\u0082\u00D3\u00CA7\u00EA.\u00D1\x0BD\x01=OQxl\u008F\x05\u00AEN\u00BB\u0081M\u00FB\u0090\u00C1\u00FB\u009F\x1E1\u00F0g\u00C7\x18\u00DB3\u00C6\u00F6\u00DF..\u008A\u00E2V\x14\u00C5-\u0095\u00A7Tp\x18\u0086\u00D30\f\u00A7T~\u0097\x02\u00E5y\u00FE\u00A1\u0094Z\u00DF\u00F3<_\u009E\u00DD$\x15\u00B7m{\u0096RBJ\u0089\u00B6m\u00CF)7O\u00C5Y\u0096]\u00AC\u00B5\b! \u0084\x00k-\u00B2,{\u00BFXk}\x15B\u00C0{\x0F\u00EF=\u0084\x10\u00D0Z_\u00DF\x12s\u00CE\u00951\x061\u00C6\u00B58\u00C6\bc\f8\u00E7\u00EAeq\u00D34\u00F7\u00B2,ADX\u0096\x05\u00CB\u00B2\u0080\u0088P\u0096%\u009A\u00A6\u00B9\u00BF$&\u00A2C\u00DF\u00F7\u0090RB\b\u00B1\x16\x0B! \u00A5D\u00D7u \u00A2\u00C3f\u00B1R\u00EAQU\x15\u00A6i\u0082sn\x15;\u00E70M\x13\u00EA\u00BA\u0086R\u00EA\u00F1Uu\u00D2\u00C6q\u008C\u00E38\u00C6T>\u00E9\u0083\x00@\baSH\u00B2\u00D8{\u00FF\u00CB\u00C4\u00C7\u00E3q\u0093\u00F8\x7F?\u00BFOw\u00DCa\u00D4\u00FD\u00F9\b-\x00\x00\x00\x00IEND\u00AEB`\u0082"
  "\u0089PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\x16\x00\x00\x00\x16\b\x06\x00\x00\x00\u00C4\u00B4l;\x00\x00\x01\u0090IDAT8\u008D\u00ED\u0093\u00BBj\x02A\x18\u0085\u00CF\u00BA\u009B\u00D9-\u00BC\u0080`\u009FJ\u00EC\u00D6\u00C5*\u0085O\u00A1\u00CF`\u0095\u00D27\x10{K\x13o`\u00A5\u0095\"\b\u00BA\u0083\u00AD\u00A0\u00CD\u008A\b\u0082\u0085\u00EF\u00E0\n\u00BB\u0090DO\n\u0089\u0090\u00C4$&\x06\u00D2\u00E4\u0083)\u00E6\u00FF\u00E1\u00CC\u00F9/\x03\u00FC\u00F3'(\u008Ar\u00A5(\u00CA\u00D5%\x1A\u0081S\u00C1d2\u00F9`\x18\u00C6M,\x16{\u00D04\u00ED\u00FA\u0092\x07^\u0091J\u00A5\u00B8^\u00AFY.\u0097\u0099N\u00A7\x19\u008DF\x19\u0089D\u00EE.\u00AD\x02\x00\u00D0\u00EDv9\u009F\u00CF9\u009B\u00CD\u00D8\u00EF\u00F7\u0099\u00CB\u00E5\b\x00\u00E7V\u00A1|\u0094\u00C8f\u00B3,\x14\n\u00F0<\u00EF\x18\u00F3<\x0F\u008E\u00E3\u00A0\u00DDnc\u00B9\\b\u00B7\u00DB\u00DD\u00BB\u00AE{K\u00F2\u00F1la\x00\x18\u008F\u00C7TU\u00F5]\\UUl\u00B7[H)\u00D1\u00EB\u00F5\u00B8X,\u00DE\u00CD\u00EA\u00E4\u00F0^\x18\f\x06\x10B`\u00BF\u00DF\x1F\u008F\x10\x02\u00E1p\x18B\bh\u009A\u0086S\u00A2_:\u00B6,\u008B\u0095J\x05\u00BE\u00EF\x03\x00\f\u00C3\u0080\u00EF\u00FB(\u0095J\u00E8t:\u00E2T\x0B\u00CEr\u00EC8\u008E\u00B2Z\u00AD\u008E\u00F7`0\u0088P(\u0084L&\x03\u0092O\u009Fm\u00C9\u00A7\u00C2\x00\u00D0j\u00B5\u00A0\u00EB:t]G\u00B1X\u00C4f\u00B3A<\x1EG\u00B3\u00D9\u00DC\u0093|\u00BCh\x05\u00A5\u0094\u0094R\x128\u00B4g4\x1Aq2\u0099\u00B0\u00D1h\x108\u00FC\u00D4o;\x06\x00\u00DB\u00B6a\u00DB6\u0080C{\u00F2\u00F9<\\\u00D7E\"\u0091@\u00B5Ze \x10\u0088\u00FC\u00D8\u00F5[,\u00CB\u00E2p8\u00E4t:e\u00BD^\u00E7\u00AF\t\x03\u0080i\u009A\u00AC\u00D5j4M\u00F3w\u0085\u00FF9\u008Bg\u0094T\u00B0s\u008D<\u00C8\u00C8\x00\x00\x00\x00IEND\u00AEB`\u0082"
]

thisColor = new RGBColor([1,1,1])

###function###
runAEVersionCheck = (data) ->
  if parseFloat(app.version) < data.getCanRunVersionNumber()
    alert "This script requires After Effects #{data.getCanRunVersionName()} or greater.", data.getScriptName()
    return false
  else
    return true

isCompActive = (selComp) ->
  unless(selComp and selComp instanceof CompItem)
    return false
  else
    return true

isLayerSelected = (selLayers) ->
  if selLayers.length is 0
    return false
  else
    return true

getLocalizedText = (str) ->
  (if app.language is Language.JAPANESE then str.jp else str.en)

###ui###
buildUI = (thisObj) ->
  MAX_UI_HEIGHT_SIZE   = 18
  MAX_ICON_HEIGHT_SIZE = 22
  CC2014_UI_MARGINS    = (if (parseFloat(app.version) >= 13.1) then 1  else 0)

  thisUI = (if (thisObj instanceof Panel) then thisObj else new Window("palette", FPLData.getScriptName(), `undefined`,
    resizeable: true
  ))

  UIResource =
    """group{
      orientation:"column",
      alignment:["fill","top"],
      spacing:0,
      margins:[0,0,0,0],

      colorGrp: Panel{
        text: \"#{String(getLocalizedText({jp: "色", en: "Color"}))}\",
        spacing: 0,
        margins:[2,4,2,2],
        alignment:["fill","top"],
        orientation: "column",

        controllGrp: Group{
          spacing: 0,
          margins: [0,0,0,#{CC2014_UI_MARGINS*2}],
          orientation:"column",
          alignment:["fill","top"],

          rGrp: Group{
            spacing: 0,
            margins: [0,1,0,0],
            orientation:"row",
            alignment:["fill","top"],

            colorPanel: Button{
              text:"",
              minimumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_UI_HEIGHT_SIZE}],
              maximumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_UI_HEIGHT_SIZE}],
              alignment:["left","fill"],
              helpTip:\"#{String(getLocalizedText({jp: "赤", en: "Red"}))}\"
            },

            r: StaticText{
              text:"",
              minimumSize:[3, #{MAX_UI_HEIGHT_SIZE}],
              maximumSize:[3, #{MAX_UI_HEIGHT_SIZE}],
              alignment:["left","fill"],
              helpTip:\"#{String(getLocalizedText({jp: "赤", en: "Red"}))}\"
            },

            colorStaticText: StaticText{
              text:"R:",
              minimumSize:[15, #{MAX_UI_HEIGHT_SIZE}],
              maximumSize:[15, #{MAX_UI_HEIGHT_SIZE}],
              alignment:["left","fill"],
            },

            colorSlider: Slider{
              minvalue:0,
              maxvalue:#{COLOR_MAX_VALUE},
              value:#{COLOR_MAX_VALUE},
              minimumSize:[25, #{MAX_UI_HEIGHT_SIZE}],
              maximumSize:[5000, #{MAX_UI_HEIGHT_SIZE}],
              alignment:["fill","fill"],
              helpTip:"",
            },

            colorEdit: EditText{
              text: #{COLOR_MAX_VALUE},
              minimumSize:[40, #{MAX_UI_HEIGHT_SIZE}],
              maximumSize:[40, #{MAX_UI_HEIGHT_SIZE}],
              alignment:["right","fill"],
              helpTip:\"#{String(getLocalizedText({jp: "赤", en: "Red"}))}\"
            },
          },

          gGrp: Group{
            spacing: 0,
            margins: [0,1,0,0],
            orientation:"row",
            alignment:["fill","top"],

            colorPanel: Button{
              text:"",
              minimumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_UI_HEIGHT_SIZE}],
              maximumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_UI_HEIGHT_SIZE}],
              alignment:["left","fill"],
              helpTip:\"#{String(getLocalizedText({jp: "緑", en: "Green"}))}\"
            },

            g: StaticText{
              text:"",
              minimumSize:[3, #{MAX_UI_HEIGHT_SIZE}],
              maximumSize:[3, #{MAX_UI_HEIGHT_SIZE}],
              alignment:["left","fill"],
              helpTip:\"#{String(getLocalizedText({jp: "緑", en: "Green"}))}\"
            },

            colorStaticText: StaticText{
              text:"G:",
              minimumSize:[15, #{MAX_UI_HEIGHT_SIZE}],
              maximumSize:[15, #{MAX_UI_HEIGHT_SIZE}],
              alignment:["left","fill"],
            },

            colorSlider: Slider{
              minvalue:0,
              maxvalue:#{COLOR_MAX_VALUE},
              value:#{COLOR_MAX_VALUE},
              minimumSize:[25, #{MAX_UI_HEIGHT_SIZE}],
              maximumSize:[5000, #{MAX_UI_HEIGHT_SIZE}],
              alignment:["fill","fill"],
              helpTip:"",
            },

            colorEdit: EditText{
              text: #{COLOR_MAX_VALUE},
              minimumSize:[40, #{MAX_UI_HEIGHT_SIZE}],
              maximumSize:[40, #{MAX_UI_HEIGHT_SIZE}],
              alignment:["right","fill"],
              helpTip:\"#{String(getLocalizedText({jp: "緑", en: "Green"}))}\"
            },
          },

          bGrp: Group{
            spacing: 0,
            margins: [0,1,0,0],
            orientation:"row",
            alignment:["fill","top"],

            colorPanel: Button{
              text:"",
              minimumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_UI_HEIGHT_SIZE}],
              maximumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_UI_HEIGHT_SIZE}],
              alignment:["left","fill"],
              helpTip:\"#{String(getLocalizedText({jp: "青", en: "Blue"}))}\"
            },

            b: StaticText{
              text:"",
              minimumSize:[3, #{MAX_UI_HEIGHT_SIZE}],
              maximumSize:[3, #{MAX_UI_HEIGHT_SIZE}],
              alignment:["left","fill"],
              helpTip:\"#{String(getLocalizedText({jp: "青", en: "Blue"}))}\"
            },

            colorStaticText: StaticText{
              text:"B:",
              minimumSize:[15, #{MAX_UI_HEIGHT_SIZE}],
              maximumSize:[15, #{MAX_UI_HEIGHT_SIZE}],
              alignment:["left","fill"],
            },

            colorSlider: Slider{
              minvalue:0,
              maxvalue:#{COLOR_MAX_VALUE},
              value:#{COLOR_MAX_VALUE},
              minimumSize:[25, #{MAX_UI_HEIGHT_SIZE}],
              maximumSize:[5000, #{MAX_UI_HEIGHT_SIZE}],
              alignment:["fill","fill"],
              helpTip:"",
            },

            colorEdit: EditText{
              text: #{COLOR_MAX_VALUE},
              minimumSize:[40, #{MAX_UI_HEIGHT_SIZE}],
              maximumSize:[40, #{MAX_UI_HEIGHT_SIZE}],
              alignment:["right","fill"],
              helpTip:\"#{String(getLocalizedText({jp: "青", en: "Blue"}))}\"
            },
          },
        },

        a: Panel{
          spacing: #{CC2014_UI_MARGINS},
          alignment:["fill","top"],
          minimumSize:[1, 0],
          maximumSize:[50000, 0],
        },

        colorCodeGrp: Group{
          spacing: 0,
          margins: [0,#{CC2014_UI_MARGINS*4},0,0],
          orientation:"row",
          alignment:["fill","top"],

          setColorBtn: Button{
            spacing: 0,
            margins: [0,0,0,0],
            text:"",
            minimumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_UI_HEIGHT_SIZE}],
            maximumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_UI_HEIGHT_SIZE}],
            alignment:["left","fill"],
            helpTip:\"#{String(getLocalizedText({jp: "色", en: "Color"}))}\"
          },

          a: StaticText{
            text:"",
            minimumSize:[#{CC2014_UI_MARGINS}, #{MAX_UI_HEIGHT_SIZE}],
            maximumSize:[#{CC2014_UI_MARGINS}, #{MAX_UI_HEIGHT_SIZE}],
            alignment:["left","fill"],
            helpTip:""
          },

          colorCodeShape: StaticText{
            text:\"#{String(getLocalizedText({jp: "カラーコード #", en: "Color Code #"}))}\",
            minimumSize:[78, #{MAX_UI_HEIGHT_SIZE}],
            maximumSize:[78, #{MAX_UI_HEIGHT_SIZE}],
            alignment:["left","fill"],
            helpTip:\"#{String(getLocalizedText({jp: "カラーコード", en: "Color Code"}))}\"
          },

          colorCodeText: EditText{
            text:"FFFFFF",
            minimumSize:[60, #{MAX_UI_HEIGHT_SIZE}],
            maximumSize:[5000, #{MAX_UI_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            helpTip:\"#{String(getLocalizedText({jp: "カラーコード", en: "Color Code"}))}\"
          },
        },
      },

      opacityGrp: Panel{
        text: \"#{String(getLocalizedText({jp: "不透明度", en: "Opacity"}))}\",
        spacing: 0,
        margins:[2,4,2,0],
        alignment:["fill","top"],
        orientation: "row",

        opacitySlider: Slider{
          minvalue:0,
          maxvalue:100,
          value:100,
          minimumSize:[25, #{MAX_UI_HEIGHT_SIZE}],
          maximumSize:[5000, #{MAX_UI_HEIGHT_SIZE}],
          alignment:["fill","fill"],
          helpTip:"100",
        },

        opacityEdit: EditText{
          text:"100",
          minimumSize:[60, #{MAX_UI_HEIGHT_SIZE}],
          maximumSize:[60, #{MAX_UI_HEIGHT_SIZE}],
          alignment:["right","fill"],
          helpTip:\"#{String(getLocalizedText({jp: "不透明度", en: "Opacity"}))}\"
        },
      },

      blendModeGrp: Panel{
        text: \"#{String(getLocalizedText({jp: "合成モード", en: "Blending Mode"}))}\",
        spacing: 0,
        margins:[2,4,2,0],
        alignment:["fill","top"],
        orientation: "row",

        paraBtn: RadioButton{
          text:\"#{String(getLocalizedText({jp: _STRINGS_JP.PARA_C, en: _STRINGS_EN.PARA_C}))}\",
          value:true,
          minimumSize:[25, #{MAX_UI_HEIGHT_SIZE}],
          maximumSize:[5000, #{MAX_UI_HEIGHT_SIZE}],
          alignment:["fill","fill"],
          helpTip:\"#{String(getLocalizedText({jp: "パラ(乗算)", en: "Para(Multiply)"}))}\",
        },

        flareBtn: RadioButton{
          text:\"#{String(getLocalizedText({jp: _STRINGS_JP.FLARE_C, en: _STRINGS_EN.FLARE_C}))}\",
          value:false,
          minimumSize:[25, #{MAX_UI_HEIGHT_SIZE}],
          maximumSize:[5000, #{MAX_UI_HEIGHT_SIZE}],
          alignment:["fill","fill"],
          helpTip:\"#{String(getLocalizedText({jp: "フレア(スクリーン)", en: "Flare(Screen)"}))}\",
        },
      },

      curveTypeGrp: Panel{
        text: \"#{String(getLocalizedText({jp: "グラデーションのシェイプ", en: "Ramp Shape"}))}\",
        spacing: 0,
        margins:[2,4,2,0],
        alignment:["fill","top"],
        orientation: "row",

        linearBtn: RadioButton{
          text:\"#{String(getLocalizedText({jp: "直線状", en: "Linear Ramp"}))}\",
          value:true,
          minimumSize:[25, #{MAX_UI_HEIGHT_SIZE}],
          maximumSize:[5000, #{MAX_UI_HEIGHT_SIZE}],
          alignment:["fill","fill"],
          helpTip:""
        },

        radiusBtn: RadioButton{
          text:\"#{String(getLocalizedText({jp: "放射状", en: "Radial Ramp"}))}\",
          value:false,
          minimumSize:[25, #{MAX_UI_HEIGHT_SIZE}],
          maximumSize:[5000, #{MAX_UI_HEIGHT_SIZE}],
          alignment:["fill","fill"],
          helpTip:""
        },
      },

      scatterGrp: Panel{
        text: \"#{String(getLocalizedText({jp: "グラデーションの拡散", en: "Ramp Scatter"}))}\",
        spacing: 0,
        margins:[2,4,2,0],
        alignment:["fill","top"],
        orientation: "row",

        scatterSlider: Slider{
          minvalue:0,
          maxvalue:50,
          value:0,
          minimumSize:[25, #{MAX_UI_HEIGHT_SIZE}],
          maximumSize:[5000, #{MAX_UI_HEIGHT_SIZE}],
          alignment:["fill","fill"],
          helpTip:"",
        },

        scatterEdit: EditText{
          text:"0",
          minimumSize:[60, #{MAX_UI_HEIGHT_SIZE}],
          maximumSize:[60, #{MAX_UI_HEIGHT_SIZE}],
          alignment:["right","fill"],
          helpTip:"Ramp Scatter"
        },
      },

      arrowBtnGrp: Panel{
        text: \"#{String(getLocalizedText({jp: "光源方向", en: "Direction"}))}\",
        spacing: 0,
        margins:[0,4,0,2],
        alignment:["fill","top"],
        orientation:"column",

        topArrowBtnGrp: Group{
          spacing: 0,
          margins: [0,1,0,0],
          orientation:"row",
          alignment:["fill","top"],

          leftBtn: IconButton{
            minimumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_ICON_HEIGHT_SIZE}],
            maximumSize:[5000, #{MAX_ICON_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            properties:{
              toggle:true,
            },
            helpTip:""
          },

          a: StaticText{
            text:"",
            minimumSize:[#{CC2014_UI_MARGINS}, #{MAX_ICON_HEIGHT_SIZE}],
            maximumSize:[#{CC2014_UI_MARGINS}, #{MAX_ICON_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            helpTip:""
          },

          centerBtn: IconButton{
            minimumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_ICON_HEIGHT_SIZE}],
            maximumSize:[5000, #{MAX_ICON_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            properties:{
              toggle:true,
            },
            helpTip:""
          },

          a: StaticText{
            text:"",
            minimumSize:[#{CC2014_UI_MARGINS}, #{MAX_ICON_HEIGHT_SIZE}],
            maximumSize:[#{CC2014_UI_MARGINS}, #{MAX_ICON_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            helpTip:""
          },

          rightBtn: IconButton{
            minimumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_ICON_HEIGHT_SIZE}],
            maximumSize:[5000, #{MAX_ICON_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            properties:{
              toggle:true,
            },
            helpTip:""
          },
        },

        middleArrowBtnGrp: Group{
          spacing: 0,
          margins: [0,1,0,0],
          orientation:"row",
          alignment:["fill","top"],

          leftBtn: IconButton{
            minimumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_ICON_HEIGHT_SIZE}],
            maximumSize:[5000, #{MAX_ICON_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            properties:{
              toggle:true,
            },
            helpTip:""
          },

          a: StaticText{
            text:"",
            minimumSize:[#{CC2014_UI_MARGINS}, #{MAX_ICON_HEIGHT_SIZE}],
            maximumSize:[#{CC2014_UI_MARGINS}, #{MAX_ICON_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            helpTip:""
          },

          centerBtn: IconButton{
            minimumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_ICON_HEIGHT_SIZE}],
            maximumSize:[5000, #{MAX_ICON_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            properties:{
              toggle:true,
            },
            helpTip:""
          },

          a: StaticText{
            text:"",
            minimumSize:[#{CC2014_UI_MARGINS}, #{MAX_ICON_HEIGHT_SIZE}],
            maximumSize:[#{CC2014_UI_MARGINS}, #{MAX_ICON_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            helpTip:""
          },

          rightBtn: IconButton{
            minimumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_ICON_HEIGHT_SIZE}],
            maximumSize:[5000, #{MAX_ICON_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            properties:{
              toggle:true,
            },
            helpTip:""
          },
        },

        bottomArrowBtnGrp: Group{
          spacing: 0,
          margins: [0,1,0,0],
          orientation:"row",
          alignment:["fill","top"],

          leftBtn: IconButton{
            minimumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_ICON_HEIGHT_SIZE}],
            maximumSize:[5000, #{MAX_ICON_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            properties:{
              toggle:true,
            },
            helpTip:""
          },

          a: StaticText{
            text:"",
            minimumSize:[#{CC2014_UI_MARGINS}, #{MAX_ICON_HEIGHT_SIZE}],
            maximumSize:[#{CC2014_UI_MARGINS}, #{MAX_ICON_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            helpTip:""
          },

          centerBtn: IconButton{
            minimumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_ICON_HEIGHT_SIZE}],
            maximumSize:[5000, #{MAX_ICON_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            properties:{
              toggle:true,
            },
            helpTip:""
          },

          a: StaticText{
            text:"",
            minimumSize:[#{CC2014_UI_MARGINS}, #{MAX_ICON_HEIGHT_SIZE}],
            maximumSize:[#{CC2014_UI_MARGINS}, #{MAX_ICON_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            helpTip:""
          },

          rightBtn: IconButton{
            minimumSize:[#{MAX_UI_HEIGHT_SIZE}, #{MAX_ICON_HEIGHT_SIZE}],
            maximumSize:[5000, #{MAX_ICON_HEIGHT_SIZE}],
            alignment:["fill","fill"],
            properties:{
              toggle:true,
            },
            helpTip:""
          },
        },
      },

      funGrp: Group{
        spacing: 0,
        margins:[0,#{CC2014_UI_MARGINS},0,0],
        alignment:["fill","top"],

        applyBtn: Button{
          text:"Apply",
          minimumSize:[25, #{MAX_UI_HEIGHT_SIZE}],
          maximumSize:[5000, #{MAX_UI_HEIGHT_SIZE}],
          alignment:["fill","fill"],
          helpTip:""
        },

        a: StaticText{
          text:"",
          minimumSize:[#{CC2014_UI_MARGINS}, #{MAX_UI_HEIGHT_SIZE}],
          maximumSize:[#{CC2014_UI_MARGINS}, #{MAX_UI_HEIGHT_SIZE}],
          alignment:["fill","fill"],
          helpTip:""
        },

        helpBtn: Button{
          text:"?",
          minimumSize:[25, #{MAX_UI_HEIGHT_SIZE}],
          maximumSize:[25, #{MAX_UI_HEIGHT_SIZE}],
          alignment:["right","fill"],
          helpTip:""
        },
      },
    }"""

  thisUI.grp = thisUI.add(UIResource)
  thisUI.margins = [0, 0, 0, 0]
  thisUI.spacing = 0

  thisUI.layout.layout(true)
  thisUI.layout.resize()

  thisUI.onResizing = thisUI.onResize = () ->
    @layout.resize()

  try
    thisUI.grp.arrowBtnGrp.topArrowBtnGrp.leftBtn.icon      = ARROW_ICON[0]
    thisUI.grp.arrowBtnGrp.topArrowBtnGrp.centerBtn.icon    = ARROW_ICON[1]
    thisUI.grp.arrowBtnGrp.topArrowBtnGrp.rightBtn.icon     = ARROW_ICON[2]
    thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.leftBtn.icon   = ARROW_ICON[3]
    thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.rightBtn.icon  = ARROW_ICON[4]
    thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.leftBtn.icon   = ARROW_ICON[5]
    thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.centerBtn.icon = ARROW_ICON[6]
    thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.rightBtn.icon  = ARROW_ICON[7]
  catch err
    ###アイコンの生成に失敗した場合はテキストで表示する###
    thisUI.grp.arrowBtnGrp.topArrowBtnGrp.leftBtn.text      = "→↓"
    thisUI.grp.arrowBtnGrp.topArrowBtnGrp.centerBtn.text    = "↓"
    thisUI.grp.arrowBtnGrp.topArrowBtnGrp.rightBtn.text     = "↓←"
    thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.leftBtn.text   = "→"
    thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.centerBtn.text = "・"
    thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.rightBtn.text  = "←"
    thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.leftBtn.text   = "→↑"
    thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.centerBtn.text = "↑"
    thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.rightBtn.text  = "↑←"


  reDrawColorPanel = () ->
    thisUI.grp.colorGrp.controllGrp.rGrp.colorPanel.drawEllipse(RGBColor.RED)
    thisUI.grp.colorGrp.controllGrp.gGrp.colorPanel.drawEllipse(RGBColor.GREEN)
    thisUI.grp.colorGrp.controllGrp.bGrp.colorPanel.drawEllipse(RGBColor.BLUE)
    thisUI.grp.colorGrp.colorCodeGrp.setColorBtn.drawRect([
      thisUI.grp.colorGrp.controllGrp.rGrp.colorSlider.value / 255
      thisUI.grp.colorGrp.controllGrp.gGrp.colorSlider.value / 255
      thisUI.grp.colorGrp.controllGrp.bGrp.colorSlider.value / 255
    ])
    return

  thisUI.grp.addEventListener("mouseover", reDrawColorPanel)
  reDrawColorPanel()


  #color: e.g. [0.0, 0.5, 1.0]
  updateRGBColorText = (color) ->
    thisUI.grp.colorGrp.controllGrp.rGrp.colorEdit.text = Math.round(color[0]*COLOR_MAX_VALUE)
    thisUI.grp.colorGrp.controllGrp.gGrp.colorEdit.text = Math.round(color[1]*COLOR_MAX_VALUE)
    thisUI.grp.colorGrp.controllGrp.bGrp.colorEdit.text = Math.round(color[2]*COLOR_MAX_VALUE)

    colorCode = "#{Number(color[0]*COLOR_MAX_VALUE).toString(16)}#{Number(color[1]*COLOR_MAX_VALUE).toString(16)}#{Number(color[2]*COLOR_MAX_VALUE).toString(16)}".toUpperCase()

    switch colorCode
      when "FF00"
        colorCode = "FF0000"
      when "0FF0"
        colorCode = "00FF00"
      when "FF0FF"
        colorCode = "FF00FF"
      when "00FF"
        colorCode = "0000FF"
      when "000"
        colorCode = "000000"

    thisUI.grp.colorGrp.colorCodeGrp.colorCodeText.text = colorCode

    return 0


  #color: e.g. [0, 0.5, 1.0]
  updateRGBColorSlider = (color) ->
    thisUI.grp.colorGrp.controllGrp.rGrp.colorSlider.helpTip =
      thisUI.grp.colorGrp.controllGrp.rGrp.colorSlider.value =
        Math.round(Number(color[0])*COLOR_MAX_VALUE)
    thisUI.grp.colorGrp.controllGrp.gGrp.colorSlider.helpTip =
      thisUI.grp.colorGrp.controllGrp.gGrp.colorSlider.value =
        Math.round(Number(color[1])*COLOR_MAX_VALUE)
    thisUI.grp.colorGrp.controllGrp.bGrp.colorSlider.helpTip =
      thisUI.grp.colorGrp.controllGrp.bGrp.colorSlider.value =
        Math.round(Number(color[2])*COLOR_MAX_VALUE)

    return 0


  #color: e.g. [0, 0.5, 1.0]
  updateRGBColorPanel = (color) ->
    thisUI.grp.colorGrp.colorCodeGrp.setColorBtn.drawRect(color)
    return 0


  updatePanelColor = (color) ->
    updateRGBColorText(color)
    updateRGBColorSlider(color)
    updateRGBColorPanel(color)

    actComp = app.project.activeItem
    return 0 unless isCompActive actComp

    selLayers = actComp.selectedLayers
    return 0 unless isLayerSelected selLayers

    rampEffect = selLayers[selLayers.length-1].property(ADBE_EFFECT_PARADE).property(ADBE_RAMP)
    if rampEffect?
      rampEffect.property(START_COLOR_MATCHNAME).setValueAtSmart(actComp.time, thisColor.getColorValue())
    return 0


  thisUI.grp.colorGrp.controllGrp.rGrp.colorPanel.onClick = () ->
    thisColor.setColorValue(RGBColor.RED)
    updatePanelColor(thisColor.getColorValue())
    return 0


  thisUI.grp.colorGrp.controllGrp.gGrp.colorPanel.onClick = () ->
    thisColor.setColorValue(RGBColor.GREEN)
    updatePanelColor(thisColor.getColorValue())
    return 0


  thisUI.grp.colorGrp.controllGrp.bGrp.colorPanel.onClick = () ->
    thisColor.setColorValue(RGBColor.BLUE)
    updatePanelColor(thisColor.getColorValue())
    return 0


  thisUI.grp.colorGrp.controllGrp.rGrp.colorEdit.onChange =
  thisUI.grp.colorGrp.controllGrp.gGrp.colorEdit.onChange =
  thisUI.grp.colorGrp.controllGrp.bGrp.colorEdit.onChange = () ->
    return unless @text.length > 2

    if isNaN(@text)
      @text = @parent.colorSlider.minvalue

    if @text < @parent.colorSlider.minvalue
      @text = @parent.colorSlider.minvalue
    else if @text > @parent.colorSlider.maxvalue
      @text = @parent.colorSlider.maxvalue

    thisColor.setColorValue([
      thisUI.grp.colorGrp.controllGrp.rGrp.colorEdit.text.toString(10) / COLOR_MAX_VALUE
      thisUI.grp.colorGrp.controllGrp.gGrp.colorEdit.text.toString(10) / COLOR_MAX_VALUE
      thisUI.grp.colorGrp.controllGrp.bGrp.colorEdit.text.toString(10) / COLOR_MAX_VALUE
    ])

    updatePanelColor(thisColor.getColorValue())
    return 0


  thisUI.grp.colorGrp.colorCodeGrp.setColorBtn.onClick = () ->
    colorCode = $.colorPicker("0x#{thisUI.grp.colorGrp.colorCodeGrp.colorCodeText.text.toUpperCase()}").toString(16)
    return 0 if colorCode is ERR_PICKER

    thisColor.setColorValue([
      parseInt(colorCode.substr(0, 2), 16) / COLOR_MAX_VALUE
      parseInt(colorCode.substr(2, 2), 16) / COLOR_MAX_VALUE
      parseInt(colorCode.substr(4, 2), 16) / COLOR_MAX_VALUE
    ])

    updatePanelColor(thisColor.getColorValue())

    actComp = app.project.activeItem
    return 0 unless isCompActive actComp

    selLayers = actComp.selectedLayers
    return 0 unless isLayerSelected selLayers

    rampEffect = selLayers[selLayers.length-1].property(ADBE_EFFECT_PARADE).property(ADBE_RAMP)
    if rampEffect?
      rampEffect.property(START_COLOR_MATCHNAME).setValueAtSmart(actComp.time, thisColor.getColorValue())

    return 0


  thisUI.grp.colorGrp.colorCodeGrp.colorCodeText.onChange = () ->
    return unless @text.length is 6

    thisColor.setColorValue([
      parseInt(@text.substr(0, 2), 16) / COLOR_MAX_VALUE
      parseInt(@text.substr(2, 2), 16) / COLOR_MAX_VALUE
      parseInt(@text.substr(4, 2), 16) / COLOR_MAX_VALUE
    ])

    updatePanelColor(thisColor.getColorValue())
    return 0


  thisUI.grp.colorGrp.controllGrp.rGrp.colorSlider.onChanging =
  thisUI.grp.colorGrp.controllGrp.gGrp.colorSlider.onChanging =
  thisUI.grp.colorGrp.controllGrp.bGrp.colorSlider.onChanging = () ->
    thisColor.setColorValue([
      thisUI.grp.colorGrp.controllGrp.rGrp.colorSlider.value / COLOR_MAX_VALUE
      thisUI.grp.colorGrp.controllGrp.gGrp.colorSlider.value / COLOR_MAX_VALUE
      thisUI.grp.colorGrp.controllGrp.bGrp.colorSlider.value / COLOR_MAX_VALUE
    ])

    updatePanelColor(thisColor.getColorValue())
    return 0


  thisUI.grp.opacityGrp.opacitySlider.onChanging = () ->
    thisUI.grp.opacityGrp.opacityEdit.text = Math.round(@value)
    return 0


  thisUI.grp.opacityGrp.opacitySlider.onChange = () ->
    thisUI.grp.opacityGrp.opacityEdit.text = Math.round(@value)

    actComp = app.project.activeItem
    return 0 unless isCompActive actComp

    selLayers = actComp.selectedLayers
    return 0 unless isLayerSelected selLayers

    rampEffect = selLayers[selLayers.length-1].property(ADBE_EFFECT_PARADE).property(ADBE_RAMP)
    if rampEffect?
      selLayers[selLayers.length-1].property(ADBE_TRANSFORM_GROUP).property(ADBE_OPACITY).setValueAtSmart(actComp.time, @value)
    return 0


  thisUI.grp.opacityGrp.opacityEdit.onChange = () ->
    if isNaN(@text)
      @text = @parent.opacitySlider.maxvalue

    if @text < @parent.opacitySlider.minvalue
      @text = @parent.opacitySlider.minvalue
    else if @text > @parent.opacitySlider.maxvalue
      @text = @parent.opacitySlider.maxvalue

    @parent.opacitySlider.value = @text

    actComp = app.project.activeItem
    return 0 unless isCompActive actComp

    selLayers = actComp.selectedLayers
    return 0 unless isLayerSelected selLayers

    rampEffect = selLayers[selLayers.length-1].property(ADBE_EFFECT_PARADE).property(ADBE_RAMP)
    if rampEffect?
      selLayers[selLayers.length-1].property(ADBE_TRANSFORM_GROUP).property(ADBE_OPACITY).setValueAtSmart(actComp.time, @text)
    return 0


  thisUI.grp.blendModeGrp.paraBtn.onClick = () ->
    actComp = app.project.activeItem
    return 0 unless isCompActive actComp

    selLayers = actComp.selectedLayers
    return 0 unless isLayerSelected selLayers

    rampEffect = selLayers[selLayers.length-1].property(ADBE_EFFECT_PARADE).property(ADBE_RAMP)
    if rampEffect?
      app.beginUndoGroup FPLData.getScriptName()
      rampEffect.property(END_COLOR_MATCHNAME).setValueAtSmart(actComp.time, RGBColor.WHITE)

      selLayers[selLayers.length-1].blendingMode = BlendingMode.MULTIPLY
      selLayers[selLayers.length-1].color = [0,0,0.8]
      selLayers[selLayers.length-1].comment = getLocalizedText({jp: _STRINGS_JP.FLARE_C, en: _STRINGS_EN.FLARE_C})

      markerValue = new MarkerValue(getLocalizedText({jp: _STRINGS_JP.PARA_M, en: _STRINGS_EN.PARA_M}))
      selLayers[selLayers.length-1].property(ADBE_MARKER).setValueAtTime(selLayers[selLayers.length-1].inPoint, markerValue)
      app.endUndoGroup()

    return 0


  thisUI.grp.blendModeGrp.flareBtn.onClick = () ->
    actComp = app.project.activeItem
    return 0 unless isCompActive actComp

    selLayers = actComp.selectedLayers
    return 0 unless isLayerSelected selLayers

    rampEffect = selLayers[selLayers.length-1].property(ADBE_EFFECT_PARADE).property(ADBE_RAMP)
    if rampEffect?
      app.beginUndoGroup FPLData.getScriptName()
      rampEffect.property(END_COLOR_MATCHNAME).setValueAtSmart(actComp.time, RGBColor.BLACK)

      selLayers[selLayers.length-1].blendingMode = BlendingMode.SCREEN
      selLayers[selLayers.length-1].color = [1,0.5,0]
      selLayers[selLayers.length-1].comment = getLocalizedText({jp: _STRINGS_JP.FLARE_C, en: _STRINGS_EN.FLARE_C})

      markerValue = new MarkerValue(getLocalizedText({jp: _STRINGS_JP.FLARE_M, en: _STRINGS_EN.FLARE_M}))
      selLayers[selLayers.length-1].property(ADBE_MARKER).setValueAtTime(selLayers[selLayers.length-1].inPoint, markerValue)
      app.endUndoGroup()

    return 0


  thisUI.grp.curveTypeGrp.linearBtn.onClick = () ->
    actComp = app.project.activeItem
    return 0 unless isCompActive actComp

    selLayers = actComp.selectedLayers
    return 0 unless isLayerSelected selLayers

    rampEffect = selLayers[selLayers.length-1].property(ADBE_EFFECT_PARADE).property(ADBE_RAMP)
    if rampEffect?
      rampEffect.property(RAMP_SHAPE_MATCHNAME).setValueAtSmart(actComp.time, LINEAR_RAMP)
    return 0


  thisUI.grp.curveTypeGrp.radiusBtn.onClick = () ->
    actComp = app.project.activeItem
    return 0 unless isCompActive actComp

    selLayers = actComp.selectedLayers
    return 0 unless isLayerSelected selLayers

    rampEffect = selLayers[selLayers.length-1].property(ADBE_EFFECT_PARADE).property(ADBE_RAMP)
    if rampEffect?
      rampEffect.property(RAMP_SHAPE_MATCHNAME).setValueAtSmart(actComp.time, RADIAL_RAMP)
    return 0


  thisUI.grp.scatterGrp.scatterSlider.onChanging = () ->
    thisUI.grp.scatterGrp.scatterEdit.text = Math.round(@value)
    return 0


  thisUI.grp.scatterGrp.scatterSlider.onChange = () ->
    thisUI.grp.scatterGrp.scatterEdit.text = Math.round(@value)

    actComp = app.project.activeItem
    return 0 unless isCompActive actComp

    selLayers = actComp.selectedLayers
    return 0 unless isLayerSelected selLayers

    rampEffect = selLayers[selLayers.length-1].property(ADBE_EFFECT_PARADE).property(ADBE_RAMP)
    if rampEffect?
      rampEffect.property(RAMP_SCATTER_MATCHNAME).setValueAtSmart(actComp.time, @value)
    return 0


  thisUI.grp.scatterGrp.scatterEdit.onChange = () ->
    if isNaN(@text)
      @text = @parent.scatterSlider.minvalue

    if @text < @parent.scatterSlider.minvalue
      @text = @parent.scatterSlider.minvalue
    else if @text > @parent.scatterSlider.maxvalue
      @text = @parent.scatterSlider.maxvalue

    @parent.scatterSlider.value = @text

    actComp = app.project.activeItem
    return 0 unless isCompActive actComp

    selLayers = actComp.selectedLayers
    return 0 unless isLayerSelected selLayers

    rampEffect = selLayers[selLayers.length-1].property(ADBE_EFFECT_PARADE).property(ADBE_RAMP)
    if rampEffect?
      rampEffect.property(RAMP_SCATTER_MATCHNAME).setValueAtSmart(actComp.time, @text)
    return 0


  thisUI.grp.arrowBtnGrp.topArrowBtnGrp.leftBtn.onClick      =
  thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.leftBtn.onClick   =
  thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.leftBtn.onClick   =
  thisUI.grp.arrowBtnGrp.topArrowBtnGrp.centerBtn.onClick    =
  thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.centerBtn.onClick =
  thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.centerBtn.onClick =
  thisUI.grp.arrowBtnGrp.topArrowBtnGrp.rightBtn.onClick     =
  thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.rightBtn.onClick  =
  thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.rightBtn.onClick  = () ->
    thisUI.grp.arrowBtnGrp.topArrowBtnGrp.leftBtn.value      =
    thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.leftBtn.value   =
    thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.leftBtn.value   =
    thisUI.grp.arrowBtnGrp.topArrowBtnGrp.centerBtn.value    =
    thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.centerBtn.value =
    thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.centerBtn.value =
    thisUI.grp.arrowBtnGrp.topArrowBtnGrp.rightBtn.value     =
    thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.rightBtn.value  =
    thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.rightBtn.value  = false
    @value = true

    actComp = app.project.activeItem
    return 0 unless isCompActive actComp

    selLayers = actComp.selectedLayers
    return 0 unless isLayerSelected selLayers

    app.beginUndoGroup FPLData.getScriptName()

    rampEffect = selLayers[selLayers.length-1].property(ADBE_EFFECT_PARADE).property(ADBE_RAMP)
    if thisUI.grp.arrowBtnGrp.topArrowBtnGrp.leftBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [0, 0])

    else if thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.leftBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [0, actComp.height/2])

    else if thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.leftBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [0, actComp.height])

    else if thisUI.grp.arrowBtnGrp.topArrowBtnGrp.centerBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width/2, 0])

    else if thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.centerBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width/2, actComp.height/2])

    else if thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.centerBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width/2, actComp.height])

    else if thisUI.grp.arrowBtnGrp.topArrowBtnGrp.rightBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width, 0])

    else if thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.rightBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width, actComp.height/2])

    else if thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.rightBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width, actComp.height])

    if thisUI.grp.arrowBtnGrp.topArrowBtnGrp.centerBtn.value    or
       thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.leftBtn.value   or
       thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.centerBtn.value or
       thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.rightBtn.value  or
       thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.centerBtn.value

      rampEffect.property(END_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width/2, actComp.height/2])

    else if thisUI.grp.arrowBtnGrp.topArrowBtnGrp.leftBtn.value or
            thisUI.grp.arrowBtnGrp.topArrowBtnGrp.rightBtn.value
    else
      rampEffect.property(END_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width/2, 0])

    if thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.centerBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width/2, actComp.height/2])
      rampEffect.property(END_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width/2, 0])
      rampEffect.property(RAMP_SHAPE_MATCHNAME).setValueAtSmart(actComp.time, RADIAL_RAMP)
      thisUI.grp.curveTypeGrp.radiusBtn.value = true
    app.endUndoGroup()

    return 0


  thisUI.grp.funGrp.helpBtn.onClick = ->
    alert(
      "#{FPLData.getScriptName()} #{FPLData.getScriptVersionNumber()}\n#{getLocalizedText({jp: "#{_STRINGS_JP.AUTHOR}", en: "#{_STRINGS_EN.AUTHOR}"})}\n\n#{getLocalizedText({jp: "#{_STRINGS_JP.HELP}", en: "#{_STRINGS_EN.HELP}"})}",
      FPLData.getScriptName()
    )


  entryFunc = () ->
    actComp = app.project.activeItem
    return 0 unless isCompActive actComp

    ###レイヤーの色###
    if thisUI.grp.blendModeGrp.paraBtn.value
      layerColor = [0,0,0.8]
    else
      layerColor = [1,0.5,0]

    addedLayer = actComp.layers.addSolid(layerColor, "Effect", actComp.width, actComp.height, actComp.pixelAspect, actComp.duration)
    addedLayer.blendingMode = BlendingMode.MULTIPLY

    ###フレア/パラ コメント###
    if thisUI.grp.blendModeGrp.paraBtn.value
      addedLayer.comment = getLocalizedText({jp: _STRINGS_JP.FLARE_C, en: _STRINGS_EN.FLARE_C})
      markerValue = new MarkerValue(getLocalizedText({jp: _STRINGS_JP.PARA_M, en: _STRINGS_EN.PARA_M}))
    else
      addedLayer.comment = getLocalizedText({jp: _STRINGS_JP.FLARE_C, en: _STRINGS_EN.FLARE_C})
      markerValue = new MarkerValue(getLocalizedText({jp: _STRINGS_JP.FLARE_M, en: _STRINGS_EN.FLARE_M}))

    addedLayer.property(ADBE_MARKER).setValueAtTime(addedLayer.inPoint, markerValue)

    rampEffect = addedLayer.property(ADBE_EFFECT_PARADE).addProperty(ADBE_RAMP)

    ###グラデーションのシェイプ###
    if thisUI.grp.curveTypeGrp.linearBtn.value
      rampEffect.property(RAMP_SHAPE_MATCHNAME).setValueAtSmart(actComp.time, LINEAR_RAMP)
    else
      rampEffect.property(RAMP_SHAPE_MATCHNAME).setValueAtSmart(actComp.time, RADIAL_RAMP)

    ###グラデーションの開始###
    rampEffect.property(START_COLOR_MATCHNAME).setValueAtSmart(actComp.time, thisColor.getColorValue())

    ###グラデーションの終了###
    if thisUI.grp.arrowBtnGrp.topArrowBtnGrp.leftBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [0, 0])

    else if thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.leftBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [0, actComp.height/2])

    else if thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.leftBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [0, actComp.height])

    else if thisUI.grp.arrowBtnGrp.topArrowBtnGrp.centerBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width/2, 0])

    else if thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.centerBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width/2, actComp.height/2])
      rampEffect.property(END_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width/2, 0])
      rampEffect.property(RAMP_SHAPE_MATCHNAME).setValueAtSmart(actComp.time, RADIAL_RAMP)
      thisUI.grp.curveTypeGrp.radiusBtn.value = true

    else if thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.centerBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width/2, actComp.height])

    else if thisUI.grp.arrowBtnGrp.topArrowBtnGrp.rightBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width, 0])

    else if thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.rightBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width, actComp.height/2])

    else if thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.rightBtn.value
      rampEffect.property(START_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width, actComp.height])

    if thisUI.grp.arrowBtnGrp.topArrowBtnGrp.centerBtn.value    or
       thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.leftBtn.value   or
       thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.centerBtn.value or
       thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.rightBtn.value  or
       thisUI.grp.arrowBtnGrp.bottomArrowBtnGrp.centerBtn.value

      rampEffect.property(END_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width/2, actComp.height/2])
    else if thisUI.grp.arrowBtnGrp.topArrowBtnGrp.leftBtn.value or
            thisUI.grp.arrowBtnGrp.topArrowBtnGrp.rightBtn.value
    else
      rampEffect.property(END_OF_RAMP_MATCHNAME).setValueAtSmart(actComp.time, [actComp.width/2, 0])

    return 0


  undoEntryFunc = (data) ->
    app.beginUndoGroup data.getScriptName()
    entryFunc()
    app.endUndoGroup()
    return 0


  thisUI.grp.funGrp.applyBtn.onClick = ->
    undoEntryFunc(FPLData)
    return 0


  thisUI.grp.arrowBtnGrp.middleArrowBtnGrp.centerBtn.value = true

  unless thisUI instanceof Panel
    thisUI.center()
    thisUI.show()

  return thisUI

###start###
return 0 unless runAEVersionCheck FPLData

buildUI(@)

return 0
