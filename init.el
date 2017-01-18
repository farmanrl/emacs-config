;;Eslint Config file

;;Initial configuration
(setq user-full-name "Richard Farman")
(setq user-mail-address "farmanrl@whitman.edu")

;;Window behavior
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq inhibit-splash-screen t
      initial-scratch-message nil)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(windmove-default-keybindings)

;;Tab behavior
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq web-mode-markup-indent-offset 2) ; web-mode, html tag in html file
(setq web-mode-css-indent-offset 2) ; web-mode, css in html file
(setq web-mode-code-indent-offset 2) ; web-mode, js code in html file
(setq web-mode-attr-indent-offset 2);
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;Backup behavior
(setq make-backup-files nil)
(setq backup-directory-alist ;; Write backup files to own directory
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))
(global-auto-revert-mode t)

;;Text behavior
(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

;;Line/Col behavior
(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))
(setq column-number-mode t)
(show-paren-mode t)

;;Theme behavior
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (monokai)))
 '(custom-safe-themes
   (quote
    ("a800120841da457aa2f86b98fb9fd8df8ba682cebde033d7dbf8077c1b7d677a" "70403e220d6d7100bae7775b3334eddeb340ba9c37f4b39c189c2c29d458543b" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;Confirmation behavior
(defalias 'yes-or-no-p 'y-or-n-p)

;;Key bindings
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c C-k") 'compile)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x c") 'cheatsheet-show)

;;Initialize package archives
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;;Shell behavior
(package-install 'exec-path-from-shell)
(exec-path-from-shell-initialize)

;;Dashboard behavior
(require 'dashboard)
(dashboard-setup-startup-hook)

;;Autocomplete behavior
(ac-config-default)

;;Flycheck Behavior
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(require 'flycheck)

(add-to-list 'flycheck-checkers 'javascript-eslint)

(setq flycheck-checkers '(javascript-eslint))

(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(javascript-jshint)))

(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                          '(json-jsonlist)))

(flycheck-add-mode 'javascript-eslint 'web-mode)

;;ESLint Behavior
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (file-executable-p eslint)
      (setq-local flycheck-javascript-eslint-executable eslint))))

(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

;;Add hooks to web-mode
(add-hook 'web-mode-hook 'flycheck-mode)
(add-hook 'web-mode-hook 'rainbow-mode)
(setq web-mode-content-types-alist
      '(("jsx" . "\\.js[x]?\\'")
        ("jsx" . "\\.es6\\'")))

;;Cheatsheet Behavior
(require 'cheatsheet)
(cheatsheet-add :group "Git"
                :key "C-x g"
                :description "open magit mode")
(cheatsheet-add :group "cheatsheet"
                :key "C-x c"
                :description "open cheatsheet")

(provide 'init.el)
;;; init.el ends here
