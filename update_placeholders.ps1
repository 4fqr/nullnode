$template = Get-Content "c:\Users\geeth\Documents\Null\nullnode-main\_placeholder_template.html" -Raw

# Hacking chapters 06-26
for($i=6; $i-le 26; $i++) {
    $num = $i.ToString('00')
    $prev = ($i-1).ToString('00')
    $next = ($i+1).ToString('00')
    
    $content = $template.Replace('{{TITLE}}',"Ch$i`: Coming Soon")
    $content = $content.Replace('{{CHAPTER_TITLE}}',"Chapter $i`: Coming Soon")
    $content = $content.Replace('{{CHAPTER_SUBTITLE}}','Content in development')
    $content = $content.Replace('{{TOPIC}}','advanced topics')
    $content = $content.Replace('{{ROADMAP_LINK}}','roadmap-hacking.html')
    $content = $content.Replace('{{ROADMAP_NAME}}','Hacking')
    $content = $content.Replace('{{PREV_CHAPTER}}',"hacking-ch$prev.html")
    $content = $content.Replace('{{NEXT_CHAPTER}}',"hacking-ch$next.html")
    
    Set-Content "c:\Users\geeth\Documents\Null\nullnode-main\hacking-ch$num.html" -Value $content
    Write-Host "Updated hacking-ch$num.html"
}

# Programming chapters 01-26
for($i=1; $i-le 26; $i++) {
    $num = $i.ToString('00')
    $prev = ($i-1).ToString('00')
    $next = ($i+1).ToString('00')
    
    $content = $template.Replace('{{TITLE}}',"Ch$i`: Coming Soon")
    $content = $content.Replace('{{CHAPTER_TITLE}}',"Chapter $i`: Coming Soon")
    $content = $content.Replace('{{CHAPTER_SUBTITLE}}','Content in development')
    $content = $content.Replace('{{TOPIC}}','programming fundamentals')
    $content = $content.Replace('{{ROADMAP_LINK}}','roadmap-programming.html')
    $content = $content.Replace('{{ROADMAP_NAME}}','Programming')
    $content = $content.Replace('{{PREV_CHAPTER}}',"programming-ch$prev.html")
    $content = $content.Replace('{{NEXT_CHAPTER}}',"programming-ch$next.html")
    
    Set-Content "c:\Users\geeth\Documents\Null\nullnode-main\programming-ch$num.html" -Value $content
    Write-Host "Updated programming-ch$num.html"
}

Write-Host "`nAll placeholder chapters updated with new theme!"
