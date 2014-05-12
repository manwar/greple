=pod

=head1 NAME

aozora - Greple module for aozora-bunko proofreading

=head1 SYNOPSIS

greple -Maozora [ options ]

=head1 DESCRIPTION

L<http://www.aozora.gr.jp/KOSAKU/MANUAL_4.html>

OCR入力では、平仮名の「へぺべ」と片仮名の「ヘペベ」がしばしば入れ替わりますが、画面やプリントアウトの校正では、この誤りをみつけることは困難です。

けれど、正規表現に対応したエディタを使えば、半角の「[]」で片仮名の「ヘペベ」を囲った

    [ヘペベ]

を検索語にして、片仮名の「ヘ」「ペ」「ベ」を、まとめてチェックできます。

正規表現では、通常とは異なり、「[　]」で挟まれた一つ一つの文字すべてが検索対象として指定されます。

「[青空文庫]」で正規表現の検索を行うと、「青空文庫」という連続した四文字ではなく、「青」「空」「文」「庫」のそれぞれが拾われます。

見つけ出したい文字列のパターンをどう表現するかといった正規表現の詳細は、解説本やインターネットの記述を参考にしてください。対応するエディタについては、インターネットで調べてください。

点検グループで用いている正規表現を、参考までにリストアップしておきます。
青空文庫の校正を進める上で、これらが何をあらわしているかを理解する必要はありません。ただ、簡単なものからでも試してもらえれば、作業の効率と精度をあげるのに役立つはずです。

=over 7

=item --katakana-he

片仮名ヘペベをチェックする。

    [ヘペベ]

=item --hiragana-he

平仮名へぺべをチェックする。

（多数ヒットしすぎてチェックしづらいときは、次項の正規表現で、誤って入った平仮名へぺべをチェックしてください。）

    [へぺべ]

=item --check-he

平仮名とカタカナの「へべぺ」「ヘベペ」を両方チェックする。
それぞれ異なる色で表示される。

=item --suspicious-he

片仮名文字列に接する平仮名へぺべをみて、読み取り誤りをチェックする。

    [ァ-ヶー][へぺべ]
    [へぺべ][ァ-ヶー]

=item --lonely-katakana

片仮名文字列でない中に、一字混じった片仮名をチェックする。

    [^ァ-ヶー][ロエセカニタトリハオ][^ァ-ヶー]

=item --lonely-non-katakana

片仮名文字列の中に、一字混じった片仮名ではない文字をチェックする。

    [ァ-ヶー]+[口工七力二夕卜り一八才][ァ-ヶー]

=item --kyuji

新字ファイルに混じる旧字をチェックする。　

[亞惡壓圍爲醫壹稻飮隱營榮衞驛圓艷鹽奧應歐毆穩假價畫會壞懷繪擴殼覺學嶽樂勸卷歡罐觀關陷巖顏歸氣龜僞戲犧舊據擧峽挾狹堯曉區驅勳徑惠溪經繼莖螢輕鷄藝缺儉劍圈檢權獻縣險顯驗嚴效廣恆鑛號國濟碎齋劑櫻册雜參慘棧蠶贊殘絲齒兒辭濕實舍寫釋壽收從澁獸縱肅處敍奬將燒稱證乘剩壤孃條淨疊穰讓釀囑觸寢愼晉眞盡圖粹醉隨髓數樞聲靜齊攝竊專戰淺潛纖踐錢禪雙壯搜插爭總聰莊裝騷臟藏屬續墮體對帶滯臺瀧擇澤單擔膽團彈斷癡遲晝蟲鑄廳聽敕鎭遞鐵轉點傳黨盜燈當鬪獨讀屆繩貳惱腦霸廢拜賣麥發髮拔蠻祕濱拂佛竝變邊辨辯瓣舖穗寶襃豐沒飜槇萬滿默彌藥譯豫餘與譽搖樣謠遙來亂覽龍兩獵壘勵禮靈齡戀爐勞樓祿亙灣瑤]

=item --shinji

旧字ファイルに混じる新字をチェックする。

[亜悪圧囲為医壱稲飲隠営栄衛駅円艶塩奥応欧殴穏仮価画会壊懐絵拡殻覚学岳楽勧巻歓缶観関陥巌顔帰気亀偽戯犠旧拠挙峡挟狭尭暁区駆勲径恵渓経継茎蛍軽鶏芸欠倹剣圏検権献県険顕験厳効広恒鉱号国済砕斎剤桜冊雑参惨桟蚕賛残糸歯児辞湿実舎写釈寿収従渋獣縦粛処叙奨将焼称証乗剰壌嬢条浄畳穣譲醸嘱触寝慎晋真尽図粋酔随髄数枢声静斉摂窃専戦浅潜繊践銭禅双壮捜挿争総聡荘装騒臓蔵属続堕体対帯滞台滝択沢単担胆団弾断痴遅昼虫鋳庁聴勅鎮逓鉄転点伝党盗灯当闘独読届縄弐悩脳覇廃拝売麦発髪抜蛮秘浜払仏並変辺弁弁弁舗穂宝褒豊没翻槙万満黙弥薬訳予余与誉揺様謡遥来乱覧竜両猟塁励礼霊齢恋炉労楼禄亘湾瑶]

=item --kogaki

仮名を小書きしないファイルに紛れ込んだ、小書きをチェックする。

（物を数える際や地名などに用いる「ヶ」は、外してあります。）

    [ぁぃぅぇぉっゃゅょゎァィゥェォッャュョヮヵ]

=item --lonely-alpha

全角とするべき可能性の高い、一文字の半角アルファベットをチェックする。

    [^a-zA-Z][a-zA-Z][^a-zA-Z]

=item --dot-in-middle

半角の「.」の後に、半角のアキ（「 」）なしで文字が続くものをチェックする。

    \.([^ （）p」])

=item --space-at-eol

文末に、不要な空白（全角、半角）が入っていないかをチェックする。

    [ 　]+$

=item --suspicious-nl

空白もしくは括弧以外が文頭にきているものをみて、誤って入れられた改行をチェックする。

（底本の行あきをなぞるために入れた改行も、チェックされます。）

    ^[^　「［（『]

=item --suspicious-space

行頭の括弧の前に、青空文庫では入れないことにしている空白がないかをチェックする。

    ^　[（「『]

=item --ruby-1

ルビの中に、仮名以外がないかをチェックする。

    《[^《》]*?[^あ-んァ-ヶーゞゝヽヾ・／″＼][^《》]*?》

=item --ruby-2

ルビの文字数に対して、ルビの付く側の文字数が長めのものをみて、「｜」の入れ忘れをチェックする。

    [\x{3400}-\x{9fff}\x{f900}-\x{fa2d}々]{3,}《

=item --ruby-3

ルビの付く文字が連続するものをみて、過分割をチェックする。

    《[^》]+》[^ァ-ヶーあ-ん、。？！―,『』｜「」々]+《[^》]+》

=item --ruby-4

ルビ中の拗促音が小書きされていないものをチェックする。（正しく並みで使われているものもチェックされます。）

    《[^《》]*?[つやゆよヤヨツユ][^《》]*?》

=item --ruby

B<--ruby-[1-4]> を全部チェックする。

=item --suspicious-brace

誤入力の可能性の高い、半角の丸括弧「()」と角括弧「[]」をチェックする。

    [^U][\?\!\#-\&\(-\+\<-\>\[-\]|]

=item --rare-chars

使われることのまれな文字をチェックする。

    [′．･，‥－｢♯□｣､]

=item --susupicious-ocr

OCRの読み取りミスや誤入力が生じやすい文字をチェックする。

（以下で用いられている「|」は、検索語の区切りです。全体をコピーし、検索ウインドウにペーストします。ヒットしたものに誤りの可能性を感じたら、底本を確認してください。）

米殻|奴隸|釆女|喝釆|壷|壼|会杜|溌刺|撒去|撤布|慰籍|狼籍|酒落|曖味|瞹昧|瞹味|咋日|[気天]侯|王候|鍛治屋|掃って|帰く|因難|粛条|芸著|建薬物|表規|絵仕|猟人形|緒口|野緒|熊々|煮趣|粗の|基だ|挟まれる|立流|繁う|愚かれた|遂われる|借しく|料埋|士地|紳土|弁護土|揚所|抜露|披る|披璃|緑結び|熱柿|探夜|族行|丁推|連蜂|藤椅子|間題|振柚|限鏡|博突|乾焼|春く|海昔|撤[かきくけこ]|茄[だで]|吐潟|裟婆|呷[かきくけこ]|崇[らりるれろ]|且那|梶棒|灰暗い|瑞ぐ|沢庵潰|、辷|咄嵯|相母|きれいだた|失わたい|すまたい|状能|卯何|実似|別在|駑いた|広緑|任掛|族客|迫ひ|荼|陀俤|笶|失はり|失張|迫掛け|誥|仲聞|出違|歳の幕|警傭|対時|意気軒昴|薪手|口借し|遠反|閣魔|趣昧|貴任|崇《たた》|崇《たたり》|紆介|理寮|代日|丁日|大統頷|愛橋|天主闇|埋窟|埋屈|要頷|一骰|輿行|夕碁|哂|肓|遺《や》|柤|聨|惨澹|高梁|衿持|千渉|大低|束京|咋今|咋秋|孟蘭盆|昼問|影讐|神泌|象微|徴動|欺《か》く|遺る|軋礫|粟鼠|驕桿|戦々競々|鉄葉|愛矯|覩察|遣遥|兼葭|堂字|鄭接|天鉄羅|霊揚|奢移|お皺|清洲国|横械|横会|記情|面も|両も|兄い|年棒|逐に|吾響|件[はひふへほ]|大きた|瞬問|塞さに|タ陽|娼帰|一入|日く|精桿|沓《よう》として|沓として|沓渺|沓茫|※［＃小書き平仮名わ|一杖|欺き|夫嫁|憤れ|眠が|悴|報く|別投|絞い|普投|灯寵|韜晦|俳譜|嘲る|擬と|例巧|疳癪|倦も|咳私|一過間|逮廻し|時聞|風間|教本|二と|覚東|衛道|姻突|後喬|共処|鱧|夏に|おるす|摘ん|駁諭|弩窿|追億|読計|臓腋|冒演|冒漬|乾操|出鱈日|移しい|灰燈|散術|限石|塵挨|夫死|髪髴|距雌|七首|任様|棒給|前蝕|タメ急|看護嫁|暮口|績り|備われ|[^相]違[さしすせそ]|達[わいうえ]|覚倍|両《しか》|判延|遠いあ|探[いくけき]|幕史|無隈|端侃|依沽地|摩《なび》|旅騎兵|蕉村|なちば|冩《うつ》|外冠|追る|摩詞不思議|愚かれ|膝顕|什《たお》れ|幕史|廷喜|於で|視神|蝦蝮|実李|鳴咽|──|凡帳面|鐡道|訊間|兔状|艮|末練|一暼|錬倉|郡屋|指輸|手祈|事惰|落書き|亊|擧[校生]|桑かい|嗚[っつ]た|反封|膀手|俤間|伺うし|金昆羅|喇叺|取倣|剌[さしすせそ]|世事|、、|。。|。、|、。|！、|[氣気]特|夾|[反訪]間|此虞|画し|竸|末だ|眥|鳴呼|叮噂|柳か|変た|朦瀧|杯《など》|新開|楝瓦|[へれね]ぱ|譯山|衿り|活撥|[まで]しよう|間達|達う|迫々|咋年|なけれは|含は|人[らりるれろ]|入間|酉洋|相達|あさらか|方画|那蘇|字音|項戴|食掌|肯像|潜越|黙心|畢竜|停立|比際|洒が|任所|木當|亭圭|浩身|母現|牀|速れ|缺鮎|傅説|[畫書]飯|[畫書]食|淡自|目分|白分|白己|感清|人地|差ず|隣れ|評到|宥《よ[いひ]》|都曾|周園|王義|卑狸|減多|腸[っつわるり]|卿筒|有舞う|木当|入家|ようた|かたり|いろいろた|静かた|勿諭|撤《ま》|一且|の問で|侯補|曖簾|[曖瞹]か|一ばい|茸|踉《つ》|真申|丸大|暖炉|燈龍|灯龍|大尺|アメリ力|宜伝|心待ちがい|等[いむまみめ]|伊大利|等敬|欺息|共時|弟一|寵[っるもられりろ]|児る|混度|漸う|巳《や》|代去|灰白い|几て|止当|瓢々|練返|徂合|酪酊|酩酎|酪酎|緑家|凛|埓|出偶|けれは|ならは|すれは|贔屑|脾睨|縞麗|逹|迴|完壁|下句|白身|眺躍

=back

=head1 SEE ALSO

L<http://www.aozora.gr.jp/KOSAKU/MANUAL_4.html>

=cut

package App::Greple::aozora;

use utf8;

1;

__DATA__

define (#asian_wide) \p{East_Asian_Width=Wide}
define (#asian_fullwidth) \p{East_Asian_Width=FullWidth}
define (#zenkaku) [(#asian_wide)(#asian_fullwidth)]

define (#katakana) \p{InKatakana}
define (#hiragana) \p{InHiragana}
define (#kanji)    \p{Han}
define (#alpha)	   [a-zA-Z]
define (#alnum)    [a-zA-Z0-9]
define (#_alnum)   [a-zA-Z0-9_]

define (#katakana::he) [ヘペベ]
define (#hiragana::he) [へぺべ]

define (#katakana-hiragana::he) (?<=(#katakana))(#hiragana::he)
define (#hiragana::he-katakana) (#hiragana::he)(?=(#katakana))
define (#he_with_katakana) (#katakana-hiragana::he)|(#hiragana::he-katakana)

option --hiragana-he --re (#hiragana::he)
option --katakana-he --re (#katakana::he)
option --check-he --hiragana-he --katakana-he --need 1
option --suspicious-he --re (#he_with_katakana)

# 人ロ増加
option --lonely-katakana --re \
	'(?<=[(#hiragana)(#kanji)])[ロエセカニタトリハオ](?=[(#hiragana)(#kanji)])'

# カタ力ナ
option --lonely-non-katakana \
	--re '(?<=(#katakana))[口工七力二夕卜り一八才](?=(#katakana))'

define (#kyuji) \
亞惡壓圍爲醫壹稻飮隱營榮衞驛圓艷鹽奧應歐毆穩假價畫會壞懷繪擴殼覺學嶽樂勸卷歡罐觀關陷巖顏歸氣龜僞戲犧舊據擧峽挾狹堯曉區驅勳徑惠溪經繼莖螢輕鷄藝缺儉劍圈檢權獻縣險顯驗嚴效廣恆鑛號國濟碎齋劑櫻册雜參慘棧蠶贊殘絲齒兒辭濕實舍寫釋壽收從澁獸縱肅處敍奬將燒稱證乘剩壤孃條淨疊穰讓釀囑觸寢愼晉眞盡圖粹醉隨髓數樞聲靜齊攝竊專戰淺潛纖踐錢禪雙壯搜插爭總聰莊裝騷臟藏屬續墮體對帶滯臺瀧擇澤單擔膽團彈斷癡遲晝蟲鑄廳聽敕鎭遞鐵轉點傳黨盜燈當鬪獨讀屆繩貳惱腦霸廢拜賣麥發髮拔蠻祕濱拂佛竝變邊辨辯瓣舖穗寶襃豐沒飜槇萬滿默彌藥譯豫餘與譽搖樣謠遙來亂覽龍兩獵壘勵禮靈齡戀爐勞樓祿亙灣瑤

define (#shinji) \
亜悪圧囲為医壱稲飲隠営栄衛駅円艶塩奥応欧殴穏仮価画会壊懐絵拡殻覚学岳楽勧巻歓缶観関陥巌顔帰気亀偽戯犠旧拠挙峡挟狭尭暁区駆勲径恵渓経継茎蛍軽鶏芸欠倹剣圏検権献県険顕験厳効広恒鉱号国済砕斎剤桜冊雑参惨桟蚕賛残糸歯児辞湿実舎写釈寿収従渋獣縦粛処叙奨将焼称証乗剰壌嬢条浄畳穣譲醸嘱触寝慎晋真尽図粋酔随髄数枢声静斉摂窃専戦浅潜繊践銭禅双壮捜挿争総聡荘装騒臓蔵属続堕体対帯滞台滝択沢単担胆団弾断痴遅昼虫鋳庁聴勅鎮逓鉄転点伝党盗灯当闘独読届縄弐悩脳覇廃拝売麦発髪抜蛮秘浜払仏並変辺弁弁弁舗穂宝褒豊没翻槙万満黙弥薬訳予余与誉揺様謡遥来乱覧竜両猟塁励礼霊齢恋炉労楼禄亘湾瑶

option --kyuji --re '[(#kyuji)]'	// 旧字を検索
option --shinji --re '[(#shinji)]'	// 新字を検索

define (#kogaki) ぁぃぅぇぉっゃゅょゎァィゥェォッャュョヮヵ
option --kogaki --re '[(#kogaki)]'

# 変数xとy
option --lonely-alpha \
	--re '(?<=(#zenkaku))(#alpha)(?=$|(#zenkaku))|^(#alpha)(?=(#zenkaku))' \
// 全角文字の中にある、一文字の半角アルファベット

option  --lonelies \
	--need 1 \
	--lonely-alpha \
	--lonely-katakana \
	--lonely-non-katakana \
	// --lonely-alpha --lonely-katakana --lonely-non-katakana

# www.example.jp
# ｗｗｗ.ｅｘａｍｐｌｅ.ｊｐ
define (#dot-in-middle) \.(?![ （）p」])
option --dot-in-middle --re '(#dot-in-middle)'

# 行末の空白 
# 行末の全角の空白　
# 行末のタブ	
option --space-at-eol --re '[ \t　]+$'

define (#char-at-bol) \　「［（『
define (#suspicious-nl) ^[^(#char-at-bol)]
option --suspicious-nl --re '(#suspicious-nl)'

option --suspicious-space --re '^　(?=[（「『])'

option --ruby-1 --re '《[^《》]*?[^あ-んァ-ヶーゞゝヽヾ・／″＼][^《》\n]*?》'
option --ruby-2 --re '[\x{3400}-\x{9fff}\x{f900}-\x{fa2d}々]{3,}《'
option --ruby-3 --re '《[^》]+》[^ァ-ヶーあ-ん、。？！―,『』｜「」々]+《[^》]+》'
option --ruby-4 --re '《[^《》]*?[つやゆよヤヨツユ][^《》]*?》'
option --ruby --ruby-1 --ruby-2 --ruby-3 --ruby-4 --need 1

define (#suspicious-brace) [^U][\?\!\#-\&\(-\+\<-\>\[-\]|]
option --suspicious-brace --re '(#suspicious-brace)'

define (#rare-chars) [′．･，‥－｢♯□｣､]
option --rare-chars --re '(#rare-chars)'

define (#suspicious-ocr) \
米殻|奴隸|釆女|喝釆|壷|壼|会杜|溌刺|撒去|撤布|慰籍|狼籍|酒落|曖味|瞹昧|瞹味|咋日|[気天]侯|王候|鍛治屋|掃って|帰く|因難|粛条|芸著|建薬物|表規|絵仕|猟人形|緒口|野緒|熊々|煮趣|粗の|基だ|挟まれる|立流|繁う|愚かれた|遂われる|借しく|料埋|士地|紳土|弁護土|揚所|抜露|披る|披璃|緑結び|熱柿|探夜|族行|丁推|連蜂|藤椅子|間題|振柚|限鏡|博突|乾焼|春く|海昔|撤[かきくけこ]|茄[だで]|吐潟|裟婆|呷[かきくけこ]|崇[らりるれろ]|且那|梶棒|灰暗い|瑞ぐ|沢庵潰|、辷|咄嵯|相母|きれいだた|失わたい|すまたい|状能|卯何|実似|別在|駑いた|広緑|任掛|族客|迫ひ|荼|陀俤|笶|失はり|失張|迫掛け|誥|仲聞|出違|歳の幕|警傭|対時|意気軒昴|薪手|口借し|遠反|閣魔|趣昧|貴任|崇《たた》|崇《たたり》|紆介|理寮|代日|丁日|大統頷|愛橋|天主闇|埋窟|埋屈|要頷|一骰|輿行|夕碁|哂|肓|遺《や》|柤|聨|惨澹|高梁|衿持|千渉|大低|束京|咋今|咋秋|孟蘭盆|昼問|影讐|神泌|象微|徴動|欺《か》く|遺る|軋礫|粟鼠|驕桿|戦々競々|鉄葉|愛矯|覩察|遣遥|兼葭|堂字|鄭接|天鉄羅|霊揚|奢移|お皺|清洲国|横械|横会|記情|面も|両も|兄い|年棒|逐に|吾響|件[はひふへほ]|大きた|瞬問|塞さに|タ陽|娼帰|一入|日く|精桿|沓《よう》として|沓として|沓渺|沓茫|※［＃小書き平仮名わ|一杖|欺き|夫嫁|憤れ|眠が|悴|報く|別投|絞い|普投|灯寵|韜晦|俳譜|嘲る|擬と|例巧|疳癪|倦も|咳私|一過間|逮廻し|時聞|風間|教本|二と|覚東|衛道|姻突|後喬|共処|鱧|夏に|おるす|摘ん|駁諭|弩窿|追億|読計|臓腋|冒演|冒漬|乾操|出鱈日|移しい|灰燈|散術|限石|塵挨|夫死|髪髴|距雌|七首|任様|棒給|前蝕|タメ急|看護嫁|暮口|績り|備われ|[^相]違[さしすせそ]|達[わいうえ]|覚倍|両《しか》|判延|遠いあ|探[いくけき]|幕史|無隈|端侃|依沽地|摩《なび》|旅騎兵|蕉村|なちば|冩《うつ》|外冠|追る|摩詞不思議|愚かれ|膝顕|什《たお》れ|幕史|廷喜|於で|視神|蝦蝮|実李|鳴咽|──|凡帳面|鐡道|訊間|兔状|艮|末練|一暼|錬倉|郡屋|指輸|手祈|事惰|落書き|亊|擧[校生]|桑かい|嗚[っつ]た|反封|膀手|俤間|伺うし|金昆羅|喇叺|取倣|剌[さしすせそ]|世事|、、|。。|。、|、。|！、|[氣気]特|夾|[反訪]間|此虞|画し|竸|末だ|眥|鳴呼|叮噂|柳か|変た|朦瀧|杯《など》|新開|楝瓦|[へれね]ぱ|譯山|衿り|活撥|[まで]しよう|間達|達う|迫々|咋年|なけれは|含は|人[らりるれろ]|入間|酉洋|相達|あさらか|方画|那蘇|字音|項戴|食掌|肯像|潜越|黙心|畢竜|停立|比際|洒が|任所|木當|亭圭|浩身|母現|牀|速れ|缺鮎|傅説|[畫書]飯|[畫書]食|淡自|目分|白分|白己|感清|人地|差ず|隣れ|評到|宥《よ[いひ]》|都曾|周園|王義|卑狸|減多|腸[っつわるり]|卿筒|有舞う|木当|入家|ようた|かたり|いろいろた|静かた|勿諭|撤《ま》|一且|の問で|侯補|曖簾|[曖瞹]か|一ばい|茸|踉《つ》|真申|丸大|暖炉|燈龍|灯龍|大尺|アメリ力|宜伝|心待ちがい|等[いむまみめ]|伊大利|等敬|欺息|共時|弟一|寵[っるもられりろ]|児る|混度|漸う|巳《や》|代去|灰白い|几て|止当|瓢々|練返|徂合|酪酊|酩酎|酪酎|緑家|凛|埓|出偶|けれは|ならは|すれは|贔屑|脾睨|縞麗|逹|迴|完壁|下句|白身|眺躍

option --suspicious-ocr --re '(#suspicious-ocr)' // OCRのミスが生じやすい文字
