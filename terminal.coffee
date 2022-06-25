format = (->'%A, %B %e %Y' + '\n' +'%-I:%M %p')()

brightness = 10

# terminal commands
userc = "whoami"  # username
datec = "date +\"#{format}\"" # date
hostc = "hostname" # hostname
batteryinfoc = "pmset -g batt | grep -oE \"[0-9]*%|'{1}[A-Za-z ]*'|[0-9]*:[[:digit:]]{2}[ ]{1}[a-z]*|no[ ]{1}[a-z]*\"" # battery/ac status, percentage, remaining time
command: "#{userc};#{datec};#{hostc};#{batteryinfoc};"

refreshFrequency: 5000

render: (output) -> """  <div id='terminal'>#{output}</div>"""

update: (output) ->
    data = output.split('\n')
    charge = data[5].replace("%", '')
    name = data[3].replace(".local", "")
    dir = "~/Desktop"
    user = data[0]
    col = ""
    colshadow = ""

    # charge = "10" # for testing the charge bar, set charge to any value
    
    symbarr = ""
    symbchargearr = ""
    symb = symbarr[(+charge)//10]
    chargestyle = "style='font-size: 25px;padding: 0px 18px 0 18px;'"
    
    if charge > 40
      col = "rgb(5, 250, 111)"
      colshadow = "0 0 #{brightness}px rgba(5, 250, 111, 0.6)"
    else if charge > 20 && charge <= 40
      col = "rgb(255, 230, 0)"
      colshadow = "0 0 #{brightness}px rgba(255, 230, 0, 0.6)"
    else
      col = "rgb(255, 0, 0)"
      colshadow = "0 0 #{brightness}px rgba(255, 0, 0, 0.6)"

    if data[4] == "'AC Power'"
      symb = symbchargearr[(+charge)//10]
      chargestyle = "style='font-size: 42px; padding: 0px 7px 0px 19px'"
      data[6] += ") "
    else 
      data[6] += ") "
    html = "<div class='wrapper'>
              <div class='watch'>

                <div class='zsh'>#{user}@#{name}: 
                  #{dir} |> now
                </div>

                <div class='time'>
                  <span id='logos'></span>
                  <~>
                  <span class='timeData'>#{data[2]}</span>
                </div>

                <div class='date'>
                  <span id='logos'></span>
                  <~>
                  <span class='dateData'>#{data[1]}</span>
                </div>

                <div class='batt' style='color: #{col};text-shadow: #{colshadow}'>
                  <span id='logos' #{chargestyle}>#{symb}</span>
                  <~>
                  <span class='battData'>
                    <span id='battbar-pro' style='width:#{charge}px;background-color:#{col}'></span>
                    <span id='battbar-pre' style='width:#{100 - charge}px;border:1px solid #{col}'></span>
                  </span>
                  #{data[5]} (#{data[6]}
                </div>

                <div class='zsh'>#{user}@#{name}:
                  #{dir} |> <div id='blink-cursor'>|</div>
                </div>

              </div>
            </div>"

    $(terminal).html(html)
  

style: (->
  return """
  
    font-size: 20px
    line-height: 35px
    width: 100%
    height: 100%
    white-space: nowrap;
    text-shadow: 0 0 #{brightness}px rgba(0, 0, 0, 0.5)

    #terminal
      width: 100%
      height: 100%

    .wrapper
      font-family: 'FiraCode Nerd Font Mono', monospace;
      position: absolute
      width: auto
    
    .batt
      display: flex

    .date
      display: flex
      color: rgb(0, 255, 255)
      text-shadow: 0 0 #{brightness}px rgba(0, 255, 255, 0.6)

    .time
      display: flex
      color: rgb(255, 165, 0)
      text-shadow: 0 0 #{brightness}px rgba(255, 165, 0, 0.6)

    .watch
      position: absolute
      color: #729fff
      margin-left: 15px
      margin-top: 10px
      
    .zsh
      font-weight: bold

    .timeData, .dateData, .battData
      margin-left: 10px

    .battData
      display: flex
      padding: 11px 10px 0px 7px
      margin-left: 6px
      color: rgba(0, 255, 0, 1)
      width: 100px
      height: 10px

    .time, .date, .batt
      margin-left: 10px

    @keyframes cursor-blink {
      0% { transform: scale(1, 0) }
      100% { transform: scale(1, 1.2) }
    }

    #blink-cursor
      animation: cursor-blink 0.5s infinite alternate
      display: inline-block

    #logos
      font-size: 35px
      padding: 0px 15px
  """
)()
