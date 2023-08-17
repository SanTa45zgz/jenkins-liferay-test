package es.ehu.doc.web.core.exceptions;

//import com.liferay.portal.security.auth.PrincipalException;
import com.liferay.portal.kernel.security.auth.PrincipalException;


public class RepoSecurityException extends PrincipalException {

	private static final long serialVersionUID = -8876274799813419133L;

	public RepoSecurityException() {
		super();
	}

	public RepoSecurityException(String msg) {
		super(msg);
	}

	public RepoSecurityException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public RepoSecurityException(Throwable cause) {
		super(cause);
	}

}