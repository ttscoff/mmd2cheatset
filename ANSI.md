title: ANSI
name: ANSI Escape Codes
keyword: ansi

&gt; `"\033[31;1;4mHello\033[0m"`

#### Colors


| name   | command              | note      |
| :---    | ---:              | :---         |
|         | Foreground colors |              |
| Black   | 30                | `\033[30;0m` |
| Red     | 31                | `\033[31;0m` |
| Green   | 32                | `\033[32;0m` |
| Yellow  | 33                | `\033[33;0m` |
| Blue    | 34                | `\033[34;0m` |
| Magenta | 35                | `\033[35;0m` |
| Cyan    | 36                | `\033[36;0m` |
| White   | 37                | `\033[37;0m` |
|         | Background colors |              |
| Black   | 40                | `\033[40;0m` |
| Red     | 41                | `\033[41;0m` |
| Green   | 42                | `\033[42;0m` |
| Yellow  | 43                | `\033[43;0m` |
| Blue    | 44                | `\033[44;0m` |
| Magenta | 45                | `\033[45;0m` |
| Cyan    | 46                | `\033[46;0m` |
| White   | 47                | `\033[47;0m` |
[Standard Colors]


| name                       | command    | note |                                                                   |
| :---                         | ---:    | :---                                                                   |
| Reset / Normal               | 0       | all attributes off                                                     |
| Bold or increased intensity  | 1       |                                                                        |
| Faint (decreased intensity)  | 2       | Not widely supported.                                                  |
| Italic                       | 3       | Not widely supported. Sometimes treated as inverse.                    |
| Underline                    | 4       |                                                                        |
| Slow Blink                   | 5       | less than 150 per minute                                               |
| Rapid Blink                  | 6       | MS-DOS ANSI.SYS; 150+ per minute; not widely supported                 |
| [[reverse video]]            | 7       | swap foreground and background colors                                  |
| Conceal                      | 8       | Not widely supported.                                                  |
| Crossed-out                  | 9       | Characters legible, but marked for deletion.  Not widely supported.    |
| Primary(default) font        | 10      |                                                                        |
| Alternate font               | 11-19   | Select alternate font `n-10`                                           |
| Fraktur                      | 20      | hardly ever supported                                                  |
| Bold off or Double Underline | 21      | Bold off not widely supported; double underline hardly ever supported. |
| Normal color or intensity    | 22      | Neither bold nor faint                                                 |
| Not italic, not Fraktur      | 23      |                                                                        |
| Underline off                | 24      | Not singly or doubly underlined                                        |
| Blink off                    | 25      |                                                                        |
| Inverse off                  | 27      |                                                                        |
| Reveal                       | 28      | conceal off                                                            |
| Not crossed out              | 29      |                                                                        |
| Set foreground color         | 30-37   | See color table below                                                  |
| Set foreground color         | 38      | Next arguments are `5;n` or `2;r;g;b`, see below                       |
| Default foreground color     | 39      | implementation defined (according to standard)                         |
| Set background color         | 40-47   | See color table below                                                  |
| Set background color         | 48      | Next arguments are `5;n` or `2;r;g;b`, see below                       |
| Default background color     | 49      | implementation defined (according to standard)                         |
| Framed                       | 51      |                                                                        |
| Encircled                    | 52      |                                                                        |
| Overlined                    | 53      |                                                                        |
| Not framed or encircled      | 54      |                                                                        |
| Not overlined                | 55      |                                                                        |
| ideogram underline           | 60      | hardly ever supported                                                  |
| ideogram double underline    | 61      | hardly ever supported                                                  |
| ideogram overline            | 62      | hardly ever supported                                                  |
| ideogram double overline     | 63      | hardly ever supported                                                  |
| ideogram stress marking      | 64      | hardly ever supported                                                  |
| ideogram attributes off      | 65      | reset the effects of all of 60-64                                      |
| Set bright foreground color  | 90-97   | aixterm (not in standard)                                              |
| Set bright background color  | 100-107 | aixterm (not in standard)                                              |
[Font Effects]


| name                      | command                                                               | note                                                                                                                                                                                                                                                                                   |
| :---                        | :---:                                                              | :---                                                                                                                                                                                                                                                                                   |
| **Cursor Position**         | `Esc[&lt;Line&gt;;&lt;Column&gt;HEsc[&lt;Line&gt;;&lt;Column&gt;f` | Moves the cursor to the specified position (coordinates). If you do not specify a position, the cursor moves to the home position at the upper-left corner of the screen (line 0, column 0). This escape sequence works the same way as the following Cursor Position escape sequence. |
| **Cursor Up**               | `Esc[&lt;Value&gt;A`                                               | Moves the cursor up by the specified number of lines without changing columns. If the cursor is already on the top line, ANSI.SYS ignores this sequence.                                                                                                                               |
| **Cursor Down**             | `Esc[&lt;Value&gt;B`                                               | Moves the cursor down by the specified number of lines without changing columns. If the cursor is already on the bottom line, ANSI.SYS ignores this sequence.                                                                                                                          |
| **Cursor Forward**          | `Esc[&lt;Value&gt;C`                                               | Moves the cursor forward by the specified number of columns without changing lines. If the cursor is already in the rightmost column, ANSI.SYS ignores this sequence.                                                                                                                  |
| **Cursor Backward**         | `Esc[&lt;Value&gt;D`                                               | Moves the cursor back by the specified number of columns without changing lines. If the cursor is already in the leftmost column, ANSI.SYS ignores this sequence.                                                                                                                      |
| **Save Cursor Position**    | `Esc[s`                                                            | Saves the current cursor position. You can move the cursor to the saved cursor position by using the Restore Cursor Position sequence.                                                                                                                                                 |
| **Restore Cursor Position** | `Esc[u`                                                            | Returns the cursor to the position stored by the Save Cursor Position sequence.                                                                                                                                                                                                        |
| **Erase Display**           | `Esc[2J`                                                           | Clears the screen and moves the cursor to the home position (line 0, column 0).                                                                                                                                                                                                        |
| **Erase &lt;Line&gt;**      | `Esc[K`                                                            | Clears all characters from the cursor position to the end of the line (including the character at the cursor position).                                                                                                                                                                |
[Cursor Movement]
