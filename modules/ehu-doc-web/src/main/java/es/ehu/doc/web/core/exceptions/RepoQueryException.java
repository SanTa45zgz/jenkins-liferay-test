package es.ehu.doc.web.core.exceptions;


public class RepoQueryException extends Exception {

	private static final long serialVersionUID = -8876274799813419133L;

	public RepoQueryException() {
		super();
	}

	public RepoQueryException(String msg) {
		super(msg);
	}

	public RepoQueryException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public RepoQueryException(Throwable cause) {
		super(cause);
	}

}