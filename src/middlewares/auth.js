import jwt from "jsonwebtoken";
import logger from "../utils/logger.js";

function isAuthenticated(req, res, next) {
    const { authorization } = req.headers;

    if (!authorization) {
        res.sendStatus(401);
    }

    try {
        const token = authorization.split(' ')[1];
        const payload = jwt.verify(token, process.env.JWT_ACCESS_SECRET);
        req.payload = payload;
        next();
    } catch (err) {
        logger(err);
        res.status(401).send(err.name);
    }
}

export { isAuthenticated };
