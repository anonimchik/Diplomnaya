<?php
    function curl_get($url, $referer='https://yandex.ru/')
    {
        $ch=curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/50.0");
        curl_setopt($ch, CURLOPT_REFERER, $referer);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $data=curl_exec($ch);
        curl_close($ch);
        return $data;
    }
	function saveImage($url,$urlImage,$imgSource){
		$ch = curl_init($url);  
		curl_setopt($ch, CURLOPT_HEADER, 0);  
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);  
		curl_setopt($ch, CURLOPT_BINARYTRANSFER,1);  
		curl_exec($ch);  
		file_put_contents($imgSource, file_get_contents($urlImage));
		curl_close($ch); 
	}
?>