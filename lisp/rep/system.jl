#| rep.system bootstrap

   $Id$

   Copyright (C) 2000 John Harper <john@dcs.warwick.ac.uk>

   This file is part of librep.

   librep is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   librep is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with librep; see the file COPYING.  If not, write to
   the Free Software Foundation, 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301 USA
|#

(declare (in-module rep.system))

(open-structures '(rep.lang.symbols
		   rep.lang.interpreter
		   rep.data
		   rep.io.files))

;;; Hook manipulation

(defun add-hook (hook-symbol new-func #!optional at-end)
  "Arrange it so that FUNCTION-NAME is added to the hook-list stored in
symbol, HOOK-SYMBOL. It will added at the head of the list unless AT-END
is true in which case it is added at the end."
  (unless (boundp hook-symbol)
    (make-variable-special hook-symbol)
    (set hook-symbol nil))
  (if at-end
      (set hook-symbol (nconc (symbol-value hook-symbol) (cons new-func nil)))
    (set hook-symbol (cons new-func (symbol-value hook-symbol)))))

(defun remove-hook (hook func)
  "Remove FUNC from the hook HOOK (symbol)."
  (when (boundp hook)
    (set hook (delete func (symbol-value hook)))))

(defun remove-hook-by-name (hook name)
  "Remove functions whose name is NAME from HOOK (a symbol)."
  (when (boundp hook)
    (set hook (delete-if (lambda (f)
			   (eq (function-name f) name))
			 (symbol-value hook)))))

(defun in-hook-p (hook-symbol fun)
  "Returns t if the function FUN is stored in the hook called HOOK-SYMBOL."
  (and (boundp hook-symbol) (memq fun (symbol-value hook-symbol))))

(export-bindings '(add-hook remove-hook remove-hook-by-name in-hook-p))

;;; misc

(autoload 'getenv "rep/system/environ")
(autoload 'setenv "rep/system/environ")
(autoload 'unsetenv "rep/system/environ")

(autoload 'pwd-prompt "rep/system/pwd-prompt")

(export-bindings '(getenv setenv unsetenv
		   operating-system rep-version rep-interface-id
		   rep-build-id pwd-prompt))
