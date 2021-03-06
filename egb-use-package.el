;;; quse-package.el --- Install and configure packages in one convenient macro. -*- lexical-binding: t; -*-
;; basing off initial commit of quse-package
;; https://github.com/jaccarmac/quse-package/commit/fd7316facec783db0c5c202d45c7350e43fe6821?diff=unified


;;;###autoload
(defmacro egb-use-package (el-get-form &rest use-package-forms)
  ;; https://emacs.stackexchange.com/questions/25026/symbols-function-definition-is-void-on-built-in-variables
  ;; You get Symbol's function definition is void because those are variables, not functions.
  (let* ((el-get-features-present (and use-package-forms (eq :features (car use-package-forms))))
         (pkgname-present (if el-get-features-present
                               (eq :pkgname (car (cddr use-package-forms)))
                             (and use-package-forms (eq :pkgname (car use-package-forms)))))
         (el-get-features (if el-get-features-present
                              (list (car use-package-forms) (cadr use-package-forms))))
         (pkgname (if pkgname-present
                      (if el-get-features-present
                          (nth 3 use-package-forms)
                        (nth 1 use-package-forms))
                    el-get-form))
         (use-package-forms (if el-get-features-present
                                (if pkgname-present
                                    (nthcdr 4 use-package-forms)
                                  (nthcdr 2 use-package-forms))
                              (if pkgname-present
                                  (nthcdr 2 use-package-forms)
                                use-package-forms))))
    `(progn
       (el-get-bundle ,el-get-form ,@el-get-features)
       (use-package ,pkgname ,@use-package-forms))))

(provide 'egb-use-package)
