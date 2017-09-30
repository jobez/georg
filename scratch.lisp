(cl-user::ecl-init-jack)

(cl-user::ecl-str-to-dsp
 (let ((*print-case* :downcase))

   (format nil "~{~{~a~#[;~%~:; = ~]~}~}"
           '((random "+(12345)~*(1103515245)")
             (noise "random/2147483647.0")
             (process noise)))))

(cl-user::ecl-connect-dsp)

(cl-user::ecl-play)

(cl-user::ecl-stop)
