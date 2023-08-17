package es.ehu.doc.web.core.exceptions;


public class RepoConnectionException extends Exception {

	private static final long serialVersionUID = 8326389746272598473L;

	public RepoConnectionException() {
		super();
	}

	public RepoConnectionException(String msg) {
		super(msg);
	}

	public RepoConnectionException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public RepoConnectionException(Throwable cause) {
		super(cause);
	}

}